/**
 *Submitted for verification at Etherscan.io on 2020-04-13
*/

pragma solidity ^0.5.8;

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
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

contract Ownable
{
    string constant internal ERROR_NO_HAVE_PERMISSION   = 'Reason: No have permission.';
    string constant internal ERROR_IS_STOPPED           = 'Reason: Is stopped.';
    string constant internal ERROR_ADDRESS_NOT_VALID    = 'Reason: Address is not valid.';
    string constant internal ERROR_CALLER_ALREADY_OWNER = 'Reason: Caller already is owner';
    string constant internal ERROR_NOT_PROPOSED_OWNER   = 'Reason: Not proposed owner';

    bool private stopped;
    address private _owner;
    address private proposedOwner;
    mapping(address => bool) private _allowed;

    event Stopped();
    event Started();
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Allowed(address indexed _address);
    event RemoveAllowed(address indexed _address);

    constructor () internal
    {
        stopped = false;
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address)
    {
        return _owner;
    }

    modifier onlyOwner()
    {
        require(isOwner(), ERROR_NO_HAVE_PERMISSION);
        _;
    }

    modifier onlyAllowed()
    {
        require(isAllowed() || isOwner(), ERROR_NO_HAVE_PERMISSION);
        _;
    }

    modifier onlyWhenNotStopped()
    {
        require(!isStopped(), ERROR_IS_STOPPED);
        _;
    }

    function isOwner() public view returns (bool)
    {
        return msg.sender == _owner;
    }

    function isAllowed() public view returns (bool)
    {
        return _allowed[msg.sender];
    }

    function allow(address _target) external onlyOwner returns (bool)
    {
        _allowed[_target] = true;
        emit Allowed(_target);
        return true;
    }

    function removeAllowed(address _target) external onlyOwner returns (bool)
    {
        _allowed[_target] = false;
        emit RemoveAllowed(_target);
        return true;
    }

    function isStopped() public view returns (bool)
    {
        if(isOwner() || isAllowed())
        {
            return false;
        }
        else
        {
            return stopped;
        }
    }

    function stop() public onlyOwner
    {
        _stop();
    }

    function start() public onlyOwner
    {
        _start();
    }

    function proposeOwner(address _proposedOwner) public onlyOwner
    {
        require(msg.sender != _proposedOwner, ERROR_CALLER_ALREADY_OWNER);
        proposedOwner = _proposedOwner;
    }

    function claimOwnership() public
    {
        require(msg.sender == proposedOwner, ERROR_NOT_PROPOSED_OWNER);

        emit OwnershipTransferred(_owner, proposedOwner);

        _owner = proposedOwner;
        proposedOwner = address(0);
    }

    function _stop() internal
    {
        emit Stopped();
        stopped = true;
    }

    function _start() internal
    {
        emit Started();
        stopped = false;
    }
}

contract BaseToken is Ownable
{
    using SafeMath for uint256;

    // MARK: error message.
    string constant internal ERROR_APPROVED_BALANCE_NOT_ENOUGH = 'Reason: Approved balance is not enough.';
    string constant internal ERROR_BALANCE_NOT_ENOUGH          = 'Reason: Balance is not enough.';
    string constant internal ERROR_LOCKED                      = 'Reason: Locked.';
    string constant internal ERROR_ADDRESS_NOT_VALID           = 'Reason: Address is not valid.';
    string constant internal ERROR_ADDRESS_IS_SAME             = 'Reason: Address is same.';
    string constant internal ERROR_VALUE_NOT_VALID             = 'Reason: Value must be greater than 0.';
    string constant internal ERROR_NO_LOCKUP                   = 'Reason: There is no lockup.';
    string constant internal ERROR_DATE_TIME_NOT_VALID         = 'Reason: Datetime must grater or equals than zero.';
    string constant internal ERROR_OUT_OF_INDEX                = 'Reason: Out of index.';
    string constant internal ERROR_TIME_IS_PAST                = 'Reason: Time is past.';

    // MARK: basic token information.
    uint256 constant public decimals = 0;
    uint256 public totalSupply;

    struct Lock {
        uint256 amount;
        uint256 expiresAt;
    }

    mapping (address => uint256) public balances;
    mapping (address => mapping ( address => uint256 )) public approvals;
    mapping (address => Lock[]) public lockup;


    // MARK: events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    event Locked(address _who,uint256 _index);
    event UnlockedAll(address _who);
    event UnlockedIndex(address _who, uint256 _index);
    event Burn(address indexed from, uint256 indexed value);

    constructor() public
    {
        balances[msg.sender] = totalSupply;
    }

    modifier transferParamsValidation(address _from, address _to, uint256 _value)
    {
        require(_from != address(0), ERROR_ADDRESS_NOT_VALID);
        require(_to != address(0), ERROR_ADDRESS_NOT_VALID);
        require(_value > 0, ERROR_VALUE_NOT_VALID);
        require(balances[_from] >= _value, ERROR_BALANCE_NOT_ENOUGH);
        require(!isLocked(_from, _value), ERROR_LOCKED);
        _;
    }

    // MARK: functions for view data
    function balanceOf(address _who) view public returns (uint256)
    {
        return balances[_who];
    }

    function lockedBalanceOf(address _who) view public returns (uint256)
    {
        require(_who != address(0), ERROR_ADDRESS_NOT_VALID);

        uint256 lockedBalance = 0;
        if(lockup[_who].length > 0)
        {
            Lock[] storage locks = lockup[_who];

            uint256 length = locks.length;
            for (uint i = 0; i < length; i++)
            {
                if (now < locks[i].expiresAt)
                {
                    lockedBalance = lockedBalance.add(locks[i].amount);
                }
            }
        }

        return lockedBalance;
    }

    function allowance(address _owner, address _spender) view external returns (uint256)
    {
        return approvals[_owner][_spender];
    }

    // true: _who can transfer token
    // false: _who can't transfer token
    function isLocked(address _who, uint256 _value) view public returns(bool)
    {
        uint256 lockedBalance = lockedBalanceOf(_who);
        uint256 balance = balanceOf(_who);

        if(lockedBalance <= 0)
        {
            return false;
        }
        else
        {
            return !(balance > lockedBalance && balance.sub(lockedBalance) >= _value);
        }
    }

    // MARK: functions for token transfer
    function transfer(address _to, uint256 _value) external onlyWhenNotStopped transferParamsValidation(msg.sender, _to, _value) returns (bool)
    {
        _transfer(msg.sender, _to, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external onlyWhenNotStopped transferParamsValidation(_from, _to, _value) returns (bool)
    {
        require(approvals[_from][msg.sender] >= _value, ERROR_APPROVED_BALANCE_NOT_ENOUGH);

        approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);

        _transfer(_from, _to, _value);

        return true;
    }

    function transferWithLock(address _to, uint256 _value, uint256 _time) onlyOwner transferParamsValidation(msg.sender, _to, _value) external returns (bool)
    {
        require(_time > now, ERROR_TIME_IS_PAST);

        _lock(_to, _value, _time);
        _transfer(msg.sender, _to, _value);

        return true;
    }

    // MARK: utils for transfer authentication
    function approve(address _spender, uint256 _value) external onlyWhenNotStopped returns (bool)
    {
        require(_spender != address(0), ERROR_VALUE_NOT_VALID);
        require(balances[msg.sender] >= _value, ERROR_BALANCE_NOT_ENOUGH);
        require(msg.sender != _spender, ERROR_ADDRESS_IS_SAME);

        approvals[msg.sender][_spender] = _value;	//injected TRANSACTION ORDER DEPENDENCE

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    // MARK: utils for amount of token
    // Lock up token until specific date time.
    function unlock(address _who, uint256 _index) onlyOwner external returns (bool)
    {
        uint256 length = lockup[_who].length;
        require(length > _index, ERROR_OUT_OF_INDEX);

        lockup[_who][_index] = lockup[_who][length - 1];
        lockup[_who].length--;

        emit UnlockedIndex(_who, _index);

        return true;
    }

    function unlockAll(address _who) onlyOwner external returns (bool)
    {
        require(lockup[_who].length > 0, ERROR_NO_LOCKUP);

        delete lockup[_who];
        emit UnlockedAll(_who);

        return true;
    }

    function burn(uint256 _value) external
    {
        require(balances[msg.sender] >= _value, ERROR_BALANCE_NOT_ENOUGH);
        require(_value > 0, ERROR_VALUE_NOT_VALID);

        balances[msg.sender] = balances[msg.sender].sub(_value);

        totalSupply = totalSupply.sub(_value);

        emit Burn(msg.sender, _value);
    }

    // MARK: internal functions
    function _transfer(address _from, address _to, uint256 _value) internal
    {
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);

        emit Transfer(_from, _to, _value);
    }

    function _lock(address _who, uint256 _value, uint256 _dateTime) onlyOwner internal
    {
        lockup[_who].push(Lock(_value, _dateTime));

        emit Locked(_who, lockup[_who].length - 1);
    }

    // destruct for only after token upgrade
    function close() onlyOwner public
    {
        selfdestruct(msg.sender);
    }
}


contract HOMIHELP is BaseToken
{
    using SafeMath for uint256;

    string constant internal ERROR_DUPLICATE_ADDRESS = 'Reason: msg.sender and receivers can not be the same.';

    // MARK: token information.
    string constant public name    = 'HOMIHELP';
    string constant public symbol  = 'HOMI';
    string constant public version = '1.0.0';

    constructor() public
    {
        totalSupply = 100000000 * (10 ** uint256(decimals));
        balances[msg.sender] = totalSupply;
    }
}