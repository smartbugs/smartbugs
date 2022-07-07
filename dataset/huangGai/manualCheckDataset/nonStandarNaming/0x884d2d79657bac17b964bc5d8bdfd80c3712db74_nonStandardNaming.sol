                                                                 

pragma solidity ^0.5.16;

interface IERC20 {
    function TOTALSUPPLY643() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF605(address account) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER78(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE980(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    function APPROVE90(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM630(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER779(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL135(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER484() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA848() internal view returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    function TOTALSUPPLY643() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }
    function BALANCEOF605(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }
    function TRANSFER78(address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER916(_MSGSENDER484(), recipient, amount);
        return true;
    }
    function ALLOWANCE980(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }
    function APPROVE90(address spender, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE737(_MSGSENDER484(), spender, amount);
        return true;
    }
    function TRANSFERFROM630(address sender, address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER916(sender, recipient, amount);
        _APPROVE737(sender, _MSGSENDER484(), _allowances[sender][_MSGSENDER484()].SUB312(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function INCREASEALLOWANCE56(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE737(_MSGSENDER484(), spender, _allowances[_MSGSENDER484()][spender].ADD968(addedValue));
        return true;
    }
    function DECREASEALLOWANCE957(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE737(_MSGSENDER484(), spender, _allowances[_MSGSENDER484()][spender].SUB312(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _TRANSFER916(address sender, address recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].SUB312(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD968(amount);
        emit TRANSFER779(sender, recipient, amount);
    }
    function _MINT550(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.ADD968(amount);
        _balances[account] = _balances[account].ADD968(amount);
        emit TRANSFER779(address(0), account, amount);
    }
    function _BURN701(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].SUB312(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB312(amount);
        emit TRANSFER779(account, address(0), amount);
    }
    function _APPROVE737(address owner, address spender, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL135(owner, spender, amount);
    }
    function _BURNFROM514(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        _BURN701(account, amount);
        _APPROVE737(account, _MSGSENDER484(), _allowances[account][_MSGSENDER484()].SUB312(amount, "ERC20: burn amount exceeds allowance"));
    }
}

library SafeMath {
    function ADD968(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function SUB312(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB312(a, b, "SafeMath: subtraction overflow");
    }
    function SUB312(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function MUL309(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function DIV143(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV143(a, b, "SafeMath: division by zero");
    }
    function DIV143(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
    function MOD945(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD945(a, b, "SafeMath: modulo by zero");
    }
    function MOD945(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
    function ISCONTRACT912(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
    function TOPAYABLE424(address account) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(account));
    }
    function SENDVALUE79(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER155(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN172(token, abi.encodeWithSelector(token.TRANSFER78.selector, to, value));
    }

    function SAFETRANSFERFROM711(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN172(token, abi.encodeWithSelector(token.TRANSFERFROM630.selector, from, to, value));
    }

    function SAFEAPPROVE528(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        require((value == 0) || (token.ALLOWANCE980(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN172(token, abi.encodeWithSelector(token.APPROVE90.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE603(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE980(address(this), spender).ADD968(value);
        CALLOPTIONALRETURN172(token, abi.encodeWithSelector(token.APPROVE90.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE308(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE980(address(this), spender).SUB312(value, "SafeERC20: decreased allowance below zero");
        CALLOPTIONALRETURN172(token, abi.encodeWithSelector(token.APPROVE90.selector, spender, newAllowance));
    }
    function CALLOPTIONALRETURN172(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        require(address(token).ISCONTRACT912(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract pLINKVault {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;
    
    struct RewardDivide {
        mapping (address => uint256) amount;
        uint256 time;
    }

    IERC20 public token = IERC20(0x514910771AF9Ca656af840dff83E8264EcF986CA);
    
    address public governance;
    uint256 public totalDeposit;
    mapping(address => uint256) public depositBalances;
    mapping(address => uint256) public rewardBalances;
    address[] public addressIndices;

    mapping(uint256 => RewardDivide) public _rewards;
    uint256 public _rewardCount = 0;

    event WITHDRAWN572(address indexed user, uint256 amount);	//inject NONSTANDARD NAMING
    
    constructor () public {
        governance = msg.sender;
    }
    
    function BALANCE902() public view returns (uint) {	//inject NONSTANDARD NAMING
        return token.BALANCEOF605(address(this));
    }
    
    function SETGOVERNANCE662(address _governance) public {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }
    
    function DEPOSITALL531() external {	//inject NONSTANDARD NAMING
        DEPOSIT826(token.BALANCEOF605(msg.sender));
    }
    
    function DEPOSIT826(uint256 _amount) public {	//inject NONSTANDARD NAMING
        require(_amount > 0, "can't deposit 0");
        
        uint arrayLength = addressIndices.length;
        
        bool found = false;
        for (uint i = 0; i < arrayLength; i++) {
            if(addressIndices[i]==msg.sender){
                found=true;
                break;
            }
        }
        
        if(!found){
            addressIndices.push(msg.sender);
        }
        
        uint256 realAmount = _amount.MUL309(995).DIV143(1000);
        uint256 feeAmount = _amount.MUL309(5).DIV143(1000);
        
        address feeAddress = 0xD319d5a9D039f06858263E95235575Bb0Bd630BC;
        address vaultAddress = 0x32e4bD46e7cee1797b22B02c0340818B6e75C75a; // Vault7 Address
        
        token.SAFETRANSFERFROM711(msg.sender, feeAddress, feeAmount);
        token.SAFETRANSFERFROM711(msg.sender, vaultAddress, realAmount);
        
        totalDeposit = totalDeposit.ADD968(realAmount);
        depositBalances[msg.sender] = depositBalances[msg.sender].ADD968(realAmount);
    }
    
    function REWARD497(uint256 _amount) external {	//inject NONSTANDARD NAMING
        require(_amount > 0, "can't reward 0");
        require(totalDeposit > 0, "totalDeposit must bigger than 0");
        
        token.SAFETRANSFERFROM711(msg.sender, address(this), _amount);

        uint arrayLength = addressIndices.length;
        for (uint i = 0; i < arrayLength; i++) {
            rewardBalances[addressIndices[i]] = rewardBalances[addressIndices[i]].ADD968(_amount.MUL309(depositBalances[addressIndices[i]]).DIV143(totalDeposit));
            _rewards[_rewardCount].amount[addressIndices[i]] = _amount.MUL309(depositBalances[addressIndices[i]]).DIV143(totalDeposit);
        }

        _rewards[_rewardCount].time = block.timestamp;
        _rewardCount++;
    } 
    
    function WITHDRAWALL236() external {	//inject NONSTANDARD NAMING
        WITHDRAW435(rewardBalances[msg.sender]);
    }
    
    function WITHDRAW435(uint256 _amount) public {	//inject NONSTANDARD NAMING
        require(_rewardCount > 0, "no reward amount");
        require(_amount > 0, "can't withdraw 0");

        uint256 availableWithdrawAmount = AVAILABLEWITHDRAW912(msg.sender);

        if (_amount > availableWithdrawAmount) {
            _amount = availableWithdrawAmount;
        }

        token.SAFETRANSFER155(msg.sender, _amount);
        
        rewardBalances[msg.sender] = rewardBalances[msg.sender].SUB312(_amount);
        emit WITHDRAWN572(msg.sender, _amount);
    }

    function AVAILABLEWITHDRAW912(address owner) public view returns(uint256){	//inject NONSTANDARD NAMING
        uint256 availableWithdrawAmount = rewardBalances[owner];
        for (uint256 i = _rewardCount - 1; block.timestamp < _rewards[i].time.ADD968(7 days); --i) {
            availableWithdrawAmount = availableWithdrawAmount.SUB312(_rewards[i].amount[owner].MUL309(_rewards[i].time.ADD968(7 days).SUB312(block.timestamp)).DIV143(7 days));
            if (i == 0) break;
        }
        return availableWithdrawAmount;
    }
}