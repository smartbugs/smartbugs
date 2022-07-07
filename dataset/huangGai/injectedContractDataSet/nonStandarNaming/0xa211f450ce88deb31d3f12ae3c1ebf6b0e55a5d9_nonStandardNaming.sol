                                                                 

// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                                    
    function ADD498(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB274(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB274(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB274(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL654(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV621(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV621(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV621(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD729(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD729(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD729(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}



                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT963(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function SENDVALUE729(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function FUNCTIONCALL6(address target, bytes memory data) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
      return FUNCTIONCALL6(target, data, "Address: low-level call failed");
    }

                                                                                                                                                                                                                       
    function FUNCTIONCALL6(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _FUNCTIONCALLWITHVALUE462(target, data, 0, errorMessage);
    }

                                                                                                                                                                                                                                                                                                                                                                   
    function FUNCTIONCALLWITHVALUE381(address target, bytes memory data, uint256 value) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALLWITHVALUE381(target, data, value, "Address: low-level call with value failed");
    }

                                                                                                                                                                                                                                                 
    function FUNCTIONCALLWITHVALUE381(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _FUNCTIONCALLWITHVALUE462(target, data, value, errorMessage);
    }

    function _FUNCTIONCALLWITHVALUE462(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(ISCONTRACT963(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER334(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN908(token, abi.encodeWithSelector(token.TRANSFER405.selector, to, value));
    }

    function SAFETRANSFERFROM317(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN908(token, abi.encodeWithSelector(token.TRANSFERFROM620.selector, from, to, value));
    }

                                                                                                                                                                                                                                                             
    function SAFEAPPROVE1000(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.ALLOWANCE653(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _CALLOPTIONALRETURN908(token, abi.encodeWithSelector(token.APPROVE25.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE228(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE653(address(this), spender).ADD498(value);
        _CALLOPTIONALRETURN908(token, abi.encodeWithSelector(token.APPROVE25.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE46(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE653(address(this), spender).SUB274(value, "SafeERC20: decreased allowance below zero");
        _CALLOPTIONALRETURN908(token, abi.encodeWithSelector(token.APPROVE25.selector, spender, newAllowance));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function _CALLOPTIONALRETURN908(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).FUNCTIONCALL6(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}


                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY17() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF989(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER405(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE653(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE25(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM620(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER530(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL714(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}


contract ParsiqBoost is IERC20 {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    uint256 constant private max_uint256627 = ~uint256(0);	//inject NONSTANDARD NAMING
    string constant public name618 = "Parsiq Boost";	//inject NONSTANDARD NAMING
    string constant public symbol984 = "PRQBOOST";	//inject NONSTANDARD NAMING
    uint8 constant public decimals986 = 18;	//inject NONSTANDARD NAMING

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;

    bytes32 public DOMAIN_SEPARATOR;
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant permit_typehash108 = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;	//inject NONSTANDARD NAMING
    mapping(address => uint256) public nonces;
    
    mapping(address => uint256) public reviewPeriods;
    mapping(address => uint256) public decisionPeriods;
    uint256 public reviewPeriod = 86400; // 1 day
    uint256 public decisionPeriod = 86400; // 1 day after review period
    address public governanceBoard;
    address public pendingGovernanceBoard;
    bool public paused = true;

    event PAUSED729();	//inject NONSTANDARD NAMING
    event UNPAUSED770();	//inject NONSTANDARD NAMING
    event REVIEWING159(address indexed account, uint256 reviewUntil, uint256 decideUntil);	//inject NONSTANDARD NAMING
    event RESOLVED875(address indexed account);	//inject NONSTANDARD NAMING
    event REVIEWPERIODCHANGED965(uint256 reviewPeriod);	//inject NONSTANDARD NAMING
    event DECISIONPERIODCHANGED72(uint256 decisionPeriod);	//inject NONSTANDARD NAMING
    event GOVERNANCEBOARDCHANGED250(address indexed from, address indexed to);	//inject NONSTANDARD NAMING
    event GOVERNEDTRANSFER838(address indexed from, address indexed to, uint256 amount);	//inject NONSTANDARD NAMING

    modifier WHENNOTPAUSED869() {	//inject NONSTANDARD NAMING
        require(!paused || msg.sender == governanceBoard, "Pausable: paused");
        _;
    }

    modifier ONLYGOVERNANCEBOARD725() {	//inject NONSTANDARD NAMING
        require(msg.sender == governanceBoard, "Sender is not governance board");
        _;
    }

    modifier ONLYPENDINGGOVERNANCEBOARD623() {	//inject NONSTANDARD NAMING
        require(msg.sender == pendingGovernanceBoard, "Sender is not the pending governance board");
        _;
    }

    modifier ONLYRESOLVED895(address account) {	//inject NONSTANDARD NAMING
        require(decisionPeriods[account] < block.timestamp, "Account is being reviewed");
        _;
    }

    constructor () public {
        _SETGOVERNANCEBOARD339(msg.sender);
        _totalSupply = 100000000e18; // 100 000 000 tokens

        _balances[msg.sender] = _totalSupply;
        emit TRANSFER530(address(0), msg.sender, _totalSupply);

        uint256 chainId;
        assembly {
            chainId := chainid()
        }

        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes(name618)),
                keccak256(bytes('1')),
                chainId,
                address(this)
            )
        );
    }

    function PAUSE102() public ONLYGOVERNANCEBOARD725 {	//inject NONSTANDARD NAMING
        require(!paused, "Pausable: paused");
        paused = true;
        emit PAUSED729();
    }

    function UNPAUSE842() public ONLYGOVERNANCEBOARD725 {	//inject NONSTANDARD NAMING
        require(paused, "Pausable: unpaused");
        paused = false;
        emit UNPAUSED770();
    }

    function REVIEW844(address account) public ONLYGOVERNANCEBOARD725 {	//inject NONSTANDARD NAMING
        _REVIEW186(account);
    }

    function RESOLVE875(address account) public ONLYGOVERNANCEBOARD725 {	//inject NONSTANDARD NAMING
        _RESOLVE668(account);
    }

    function ELECTGOVERNANCEBOARD922(address newGovernanceBoard) public ONLYGOVERNANCEBOARD725 {	//inject NONSTANDARD NAMING
        pendingGovernanceBoard = newGovernanceBoard;
    }

    function TAKEGOVERNANCE673() public ONLYPENDINGGOVERNANCEBOARD623 {	//inject NONSTANDARD NAMING
        _SETGOVERNANCEBOARD339(pendingGovernanceBoard);
        pendingGovernanceBoard = address(0);
    }

    function _SETGOVERNANCEBOARD339(address newGovernanceBoard) internal {	//inject NONSTANDARD NAMING
        emit GOVERNANCEBOARDCHANGED250(governanceBoard, newGovernanceBoard);
        governanceBoard = newGovernanceBoard;
    }

                                                     
    function TOTALSUPPLY17() public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                   
    function BALANCEOF989(address account) public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

                                                                                                                                                                                                    
    function TRANSFER405(address recipient, uint256 amount) public override 	//inject NONSTANDARD NAMING
        ONLYRESOLVED895(msg.sender)
        ONLYRESOLVED895(recipient)
        WHENNOTPAUSED869
        returns (bool) {
        _TRANSFER735(msg.sender, recipient, amount);
        return true;
    }

                                                   
    function ALLOWANCE653(address owner, address spender) public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

                                                                                                                                   
    function APPROVE25(address spender, uint256 amount) public override	//inject NONSTANDARD NAMING
        ONLYRESOLVED895(msg.sender)
        ONLYRESOLVED895(spender)
        WHENNOTPAUSED869
        returns (bool) {
        _APPROVE359(msg.sender, spender, amount);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function TRANSFERFROM620(address sender, address recipient, uint256 amount) public override	//inject NONSTANDARD NAMING
        ONLYRESOLVED895(msg.sender)
        ONLYRESOLVED895(sender)
        ONLYRESOLVED895(recipient)
        WHENNOTPAUSED869
        returns (bool) {
        _TRANSFER735(sender, recipient, amount);
        if (_allowances[sender][msg.sender] < max_uint256627) { // treat MAX_UINT256 approve as infinite approval
            _APPROVE359(sender, msg.sender, _allowances[sender][msg.sender].SUB274(amount, "ERC20: transfer amount exceeds allowance"));
        }
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                 
    function GOVERNEDTRANSFER306(address from, address to, uint256 value) public ONLYGOVERNANCEBOARD725         	//inject NONSTANDARD NAMING
        returns (bool) {
        require(block.timestamp >  reviewPeriods[from], "Review period is not elapsed");
        require(block.timestamp <= decisionPeriods[from], "Decision period expired");

        _TRANSFER735(from, to, value);
        emit GOVERNEDTRANSFER838(from, to, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                    
    function INCREASEALLOWANCE312(address spender, uint256 addedValue) public 	//inject NONSTANDARD NAMING
        ONLYRESOLVED895(msg.sender)
        ONLYRESOLVED895(spender)
        WHENNOTPAUSED869
        returns (bool) {
        _APPROVE359(msg.sender, spender, _allowances[msg.sender][spender].ADD498(addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DECREASEALLOWANCE63(address spender, uint256 subtractedValue) public 	//inject NONSTANDARD NAMING
        ONLYRESOLVED895(msg.sender)
        ONLYRESOLVED895(spender)
        WHENNOTPAUSED869
        returns (bool) {
        _APPROVE359(msg.sender, spender, _allowances[msg.sender][spender].SUB274(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function _TRANSFER735(address sender, address recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].SUB274(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD498(amount);
        emit TRANSFER530(sender, recipient, amount);
    }

                                                                                                                                                                                                                                                                                                                        
    function _BURN784(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].SUB274(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB274(amount);
        emit TRANSFER530(account, address(0), amount);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                
    function _APPROVE359(address owner, address spender, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL714(owner, spender, amount);
    }

                                                                                                      
    function BURN832(uint256 amount) public 	//inject NONSTANDARD NAMING
        ONLYRESOLVED895(msg.sender)
        WHENNOTPAUSED869
    {
        _BURN784(msg.sender, amount);
    }

    function TRANSFERMANY671(address[] calldata recipients, uint256[] calldata amounts)	//inject NONSTANDARD NAMING
        ONLYRESOLVED895(msg.sender)
        WHENNOTPAUSED869
        external {
        require(recipients.length == amounts.length, "ParsiqToken: Wrong array length");

        uint256 total = 0;
        for (uint256 i = 0; i < amounts.length; i++) {
            total = total.ADD498(amounts[i]);
        }

        _balances[msg.sender] = _balances[msg.sender].SUB274(total, "ERC20: transfer amount exceeds balance");

        for (uint256 i = 0; i < recipients.length; i++) {
            address recipient = recipients[i];
            uint256 amount = amounts[i];
            require(recipient != address(0), "ERC20: transfer to the zero address");
            require(decisionPeriods[recipient] < block.timestamp, "Account is being reviewed");

            _balances[recipient] = _balances[recipient].ADD498(amount);
            emit TRANSFER530(msg.sender, recipient, amount);
        }
    }

    function PERMIT202(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {	//inject NONSTANDARD NAMING
        // Need to unwrap modifiers to eliminate Stack too deep error
        require(decisionPeriods[owner] < block.timestamp, "Account is being reviewed");
        require(decisionPeriods[spender] < block.timestamp, "Account is being reviewed");
        require(!paused || msg.sender == governanceBoard, "Pausable: paused");
        require(deadline >= block.timestamp, 'ParsiqToken: EXPIRED');    
        bytes32 digest = keccak256(
            abi.encodePacked(
                '\x19\x01',
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(permit_typehash108, owner, spender, value, nonces[owner]++, deadline))
            )
        );

        address recoveredAddress = ecrecover(digest, v, r, s);

        require(recoveredAddress != address(0) && recoveredAddress == owner, 'ParsiqToken: INVALID_SIGNATURE');
        _APPROVE359(owner, spender, value);
    }

    function SETREVIEWPERIOD286(uint256 _reviewPeriod) public ONLYGOVERNANCEBOARD725 {	//inject NONSTANDARD NAMING
        reviewPeriod = _reviewPeriod;
        emit REVIEWPERIODCHANGED965(reviewPeriod);
    }

    function SETDECISIONPERIOD160(uint256 _decisionPeriod) public ONLYGOVERNANCEBOARD725 {	//inject NONSTANDARD NAMING
        decisionPeriod = _decisionPeriod;
        emit DECISIONPERIODCHANGED72(decisionPeriod);
    }

    function RECOVERTOKENS78(IERC20 token, address to, uint256 amount) public ONLYGOVERNANCEBOARD725 {	//inject NONSTANDARD NAMING
        uint256 balance = token.BALANCEOF989(address(this));
        require(balance >= amount, "ERC20: Insufficient balance");
        token.SAFETRANSFER334(to, amount);
    }

    function _REVIEW186(address account) internal {	//inject NONSTANDARD NAMING
        uint256 reviewUntil = block.timestamp.ADD498(reviewPeriod);
        uint256 decideUntil = block.timestamp.ADD498(reviewPeriod.ADD498(decisionPeriod));
        reviewPeriods[account] = reviewUntil;
        decisionPeriods[account] = decideUntil;
        emit REVIEWING159(account, reviewUntil, decideUntil);
    }

    function _RESOLVE668(address account) internal {	//inject NONSTANDARD NAMING
        reviewPeriods[account] = 0;
        decisionPeriods[account] = 0;
        emit RESOLVED875(account);
    }
}