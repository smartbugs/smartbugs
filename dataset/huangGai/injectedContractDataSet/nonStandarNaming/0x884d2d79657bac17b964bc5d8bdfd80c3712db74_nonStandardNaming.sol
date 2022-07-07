                                                                 

pragma solidity ^0.5.16;

interface IERC20 {
    function TOTALSUPPLY39() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF342(address account) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER892(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE335(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    function APPROVE49(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM790(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER356(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL503(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER272() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA393() internal view returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    function TOTALSUPPLY39() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }
    function BALANCEOF342(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }
    function TRANSFER892(address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER337(_MSGSENDER272(), recipient, amount);
        return true;
    }
    function ALLOWANCE335(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }
    function APPROVE49(address spender, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE27(_MSGSENDER272(), spender, amount);
        return true;
    }
    function TRANSFERFROM790(address sender, address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER337(sender, recipient, amount);
        _APPROVE27(sender, _MSGSENDER272(), _allowances[sender][_MSGSENDER272()].SUB956(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function INCREASEALLOWANCE743(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE27(_MSGSENDER272(), spender, _allowances[_MSGSENDER272()][spender].ADD786(addedValue));
        return true;
    }
    function DECREASEALLOWANCE224(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE27(_MSGSENDER272(), spender, _allowances[_MSGSENDER272()][spender].SUB956(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _TRANSFER337(address sender, address recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].SUB956(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD786(amount);
        emit TRANSFER356(sender, recipient, amount);
    }
    function _MINT977(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.ADD786(amount);
        _balances[account] = _balances[account].ADD786(amount);
        emit TRANSFER356(address(0), account, amount);
    }
    function _BURN905(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].SUB956(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB956(amount);
        emit TRANSFER356(account, address(0), amount);
    }
    function _APPROVE27(address owner, address spender, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL503(owner, spender, amount);
    }
    function _BURNFROM541(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        _BURN905(account, amount);
        _APPROVE27(account, _MSGSENDER272(), _allowances[account][_MSGSENDER272()].SUB956(amount, "ERC20: burn amount exceeds allowance"));
    }
}

library SafeMath {
    function ADD786(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function SUB956(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB956(a, b, "SafeMath: subtraction overflow");
    }
    function SUB956(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function MUL88(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function DIV343(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV343(a, b, "SafeMath: division by zero");
    }
    function DIV343(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
    function MOD197(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD197(a, b, "SafeMath: modulo by zero");
    }
    function MOD197(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
    function ISCONTRACT818(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
    function TOPAYABLE126(address account) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(account));
    }
    function SENDVALUE5(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER46(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN200(token, abi.encodeWithSelector(token.TRANSFER892.selector, to, value));
    }

    function SAFETRANSFERFROM146(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN200(token, abi.encodeWithSelector(token.TRANSFERFROM790.selector, from, to, value));
    }

    function SAFEAPPROVE172(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        require((value == 0) || (token.ALLOWANCE335(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN200(token, abi.encodeWithSelector(token.APPROVE49.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE235(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE335(address(this), spender).ADD786(value);
        CALLOPTIONALRETURN200(token, abi.encodeWithSelector(token.APPROVE49.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE541(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE335(address(this), spender).SUB956(value, "SafeERC20: decreased allowance below zero");
        CALLOPTIONALRETURN200(token, abi.encodeWithSelector(token.APPROVE49.selector, spender, newAllowance));
    }
    function CALLOPTIONALRETURN200(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        require(address(token).ISCONTRACT818(), "SafeERC20: call to non-contract");

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

    event WITHDRAWN459(address indexed user, uint256 amount);	//inject NONSTANDARD NAMING
    
    constructor () public {
        governance = msg.sender;
    }
    
    function BALANCE221() public view returns (uint) {	//inject NONSTANDARD NAMING
        return token.BALANCEOF342(address(this));
    }
    
    function SETGOVERNANCE269(address _governance) public {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }
    
    function DEPOSITALL567() external {	//inject NONSTANDARD NAMING
        DEPOSIT500(token.BALANCEOF342(msg.sender));
    }
    
    function DEPOSIT500(uint256 _amount) public {	//inject NONSTANDARD NAMING
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
        
        uint256 realAmount = _amount.MUL88(995).DIV343(1000);
        uint256 feeAmount = _amount.MUL88(5).DIV343(1000);
        
        address feeAddress = 0xD319d5a9D039f06858263E95235575Bb0Bd630BC;
        address vaultAddress = 0x32e4bD46e7cee1797b22B02c0340818B6e75C75a; // Vault7 Address
        
        token.SAFETRANSFERFROM146(msg.sender, feeAddress, feeAmount);
        token.SAFETRANSFERFROM146(msg.sender, vaultAddress, realAmount);
        
        totalDeposit = totalDeposit.ADD786(realAmount);
        depositBalances[msg.sender] = depositBalances[msg.sender].ADD786(realAmount);
    }
    
    function REWARD357(uint256 _amount) external {	//inject NONSTANDARD NAMING
        require(_amount > 0, "can't reward 0");
        require(totalDeposit > 0, "totalDeposit must bigger than 0");
        
        token.SAFETRANSFERFROM146(msg.sender, address(this), _amount);

        uint arrayLength = addressIndices.length;
        for (uint i = 0; i < arrayLength; i++) {
            rewardBalances[addressIndices[i]] = rewardBalances[addressIndices[i]].ADD786(_amount.MUL88(depositBalances[addressIndices[i]]).DIV343(totalDeposit));
            _rewards[_rewardCount].amount[addressIndices[i]] = _amount.MUL88(depositBalances[addressIndices[i]]).DIV343(totalDeposit);
        }

        _rewards[_rewardCount].time = block.timestamp;
        _rewardCount++;
    } 
    
    function WITHDRAWALL757() external {	//inject NONSTANDARD NAMING
        WITHDRAW270(rewardBalances[msg.sender]);
    }
    
    function WITHDRAW270(uint256 _amount) public {	//inject NONSTANDARD NAMING
        require(_rewardCount > 0, "no reward amount");
        require(_amount > 0, "can't withdraw 0");

        uint256 availableWithdrawAmount = AVAILABLEWITHDRAW17(msg.sender);

        if (_amount > availableWithdrawAmount) {
            _amount = availableWithdrawAmount;
        }

        token.SAFETRANSFER46(msg.sender, _amount);
        
        rewardBalances[msg.sender] = rewardBalances[msg.sender].SUB956(_amount);
        emit WITHDRAWN459(msg.sender, _amount);
    }

    function AVAILABLEWITHDRAW17(address owner) public view returns(uint256){	//inject NONSTANDARD NAMING
        uint256 availableWithdrawAmount = rewardBalances[owner];
        for (uint256 i = _rewardCount - 1; block.timestamp < _rewards[i].time.ADD786(7 days); --i) {
            availableWithdrawAmount = availableWithdrawAmount.SUB956(_rewards[i].amount[owner].MUL88(_rewards[i].time.ADD786(7 days).SUB956(block.timestamp)).DIV343(7 days));
            if (i == 0) break;
        }
        return availableWithdrawAmount;
    }
}