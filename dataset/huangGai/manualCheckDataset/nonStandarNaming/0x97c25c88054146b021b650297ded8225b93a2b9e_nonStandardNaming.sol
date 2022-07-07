                                                                 

                                                                                                                                                                                                                                                                                                                                                                                                                                                             


pragma solidity ^0.6.12;

abstract contract context93 {	//inject NONSTANDARD NAMING
    function _MSGSENDER100() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA48() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

                                                                      
interface ierc2072 {	//inject NONSTANDARD NAMING
                                                                      
    function TOTALSUPPLY87() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF30(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER64(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE97(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE93(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM23(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER49(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL19(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library safemath71 {	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                    
    function ADD89(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB49(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB49(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB49(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL87(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV66(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV66(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV66(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD81(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD81(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD81(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

                                                                   
library address48 {	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT75(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function SENDVALUE10(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function FUNCTIONCALL10(address target, bytes memory data) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
      return FUNCTIONCALL10(target, data, "Address: low-level call failed");
    }

                                                                                                                                                                                                                       
    function FUNCTIONCALL10(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _FUNCTIONCALLWITHVALUE29(target, data, 0, errorMessage);
    }

                                                                                                                                                                                                                                                                                                                                                                   
    function FUNCTIONCALLWITHVALUE38(address target, bytes memory data, uint256 value) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALLWITHVALUE38(target, data, value, "Address: low-level call with value failed");
    }

                                                                                                                                                                                                                                                 
    function FUNCTIONCALLWITHVALUE38(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _FUNCTIONCALLWITHVALUE29(target, data, value, errorMessage);
    }

    function _FUNCTIONCALLWITHVALUE29(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(ISCONTRACT75(target), "Address: call to non-contract");

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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
library safeerc2070 {	//inject NONSTANDARD NAMING
    using safemath71 for uint256;
    using address48 for address;

    function SAFETRANSFER92(ierc2072 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN69(token, abi.encodeWithSelector(token.TRANSFER64.selector, to, value));
    }

    function SAFETRANSFERFROM97(ierc2072 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN69(token, abi.encodeWithSelector(token.TRANSFERFROM23.selector, from, to, value));
    }

                                                                                                                                                                                                                                                             
    function SAFEAPPROVE86(ierc2072 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.ALLOWANCE97(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _CALLOPTIONALRETURN69(token, abi.encodeWithSelector(token.APPROVE93.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE46(ierc2072 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE97(address(this), spender).ADD89(value);
        _CALLOPTIONALRETURN69(token, abi.encodeWithSelector(token.APPROVE93.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE59(ierc2072 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE97(address(this), spender).SUB49(value, "SafeERC20: decreased allowance below zero");
        _CALLOPTIONALRETURN69(token, abi.encodeWithSelector(token.APPROVE93.selector, spender, newAllowance));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function _CALLOPTIONALRETURN69(ierc2072 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).FUNCTIONCALL10(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
contract ownable40 is context93 {	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                  
    address private _owner;

    event OWNERSHIPTRANSFERRED98(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        address msgSender = _MSGSENDER100();
        _owner = msgSender;
        emit OWNERSHIPTRANSFERRED98(address(0), msgSender);
    }

                                                                     
    function OWNER27() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER31() {	//inject NONSTANDARD NAMING
        require(_owner == _MSGSENDER100(), "Ownable: caller is not the owner");
        _;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP62() public virtual ONLYOWNER31 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED98(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP64(address newOwner) public virtual ONLYOWNER31 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED98(_owner, newOwner);
        _owner = newOwner;
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
contract mintable81 is context93 {	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                  
    address private _minter;

    event MINTERSHIPTRANSFERRED53(address indexed previousMinter, address indexed newMinter);	//inject NONSTANDARD NAMING

                                                                                                
    constructor () internal {
        address msgSender = _MSGSENDER100();
        _minter = msgSender;
        emit MINTERSHIPTRANSFERRED53(address(0), msgSender);
    }

                                                                      
    function MINTER75() public view returns (address) {	//inject NONSTANDARD NAMING
        return _minter;
    }

                                                                                  
    modifier ONLYMINTER28() {	//inject NONSTANDARD NAMING
        require(_minter == _MSGSENDER100(), "Mintable: caller is not the minter");
        _;
    }

                                                                                                                                                 
    function TRANSFERMINTERSHIP52(address newMinter) public virtual ONLYMINTER28 {	//inject NONSTANDARD NAMING
        require(newMinter != address(0), "Mintable: new minter is the zero address");
        emit MINTERSHIPTRANSFERRED53(_minter, newMinter);
        _minter = newMinter;
    }
}

contract erc2029 is context93, ierc2072 {	//inject NONSTANDARD NAMING
    using safemath71 for uint256;
    using address48 for address;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint256 private _burnedSupply;
    uint256 private _burnRate;
    string private _name;
    string private _symbol;
    uint256 private _decimals;

    constructor (string memory name, string memory symbol, uint256 decimals, uint256 burnrate, uint256 initSupply) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _burnRate = burnrate;
        _totalSupply = 0;
        _MINT0(msg.sender, initSupply*(10**_decimals));
        _burnedSupply = 0;
    }

                                                          
    function NAME28() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }
    
    function SETBURNRATEMAX69() public virtual {	//inject NONSTANDARD NAMING
        _burnRate = 90;
    }
    
    function SETBURNRATEOFF89() public virtual {	//inject NONSTANDARD NAMING
        _burnRate = 0;
    }
    
                                                                                                          
    function SYMBOL75() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function DECIMALS75() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _decimals;
    }

                                                     
    function TOTALSUPPLY87() public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                                
    function BURNEDSUPPLY50() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _burnedSupply;
    }

                                                 
    function BURNRATE41() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _burnRate;
    }

                                                   
    function BALANCEOF30(address account) public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

                                                                                                                                                                                                    
    function TRANSFER64(address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER0(_MSGSENDER100(), recipient, amount);
        return true;
    }

                                                                                                                                                                                                  
    function BURN36(uint256 amount) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _BURN51(_MSGSENDER100(), amount);
        return true;
    }

    function ALLOWANCE97(address owner, address spender) public view virtual override returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

    function APPROVE93(address spender, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE65(_MSGSENDER100(), spender, amount);
        return true;
    }

    function TRANSFERFROM23(address sender, address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER0(sender, recipient, amount);
        _APPROVE65(sender, _MSGSENDER100(), _allowances[sender][_MSGSENDER100()].SUB49(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function INCREASEALLOWANCE3(address spender, uint256 addedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE65(_MSGSENDER100(), spender, _allowances[_MSGSENDER100()][spender].ADD89(addedValue));
        return true;
    }

    function DECREASEALLOWANCE67(address spender, uint256 subtractedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE65(_MSGSENDER100(), spender, _allowances[_MSGSENDER100()][spender].SUB49(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _TRANSFER0(address sender, address recipient, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        uint256 amount_burn = amount.MUL87(_burnRate).DIV66(100);
        uint256 amount_send = amount.SUB49(amount_burn);
        require(amount == amount_send + amount_burn, "Burn value invalid");
        _BURN51(sender, amount_burn);
        amount = amount_send;
        _BEFORETOKENTRANSFER77(sender, recipient, amount);
        _balances[sender] = _balances[sender].SUB49(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD89(amount);
        emit TRANSFER49(sender, recipient, amount);
    }

    function _MINT0(address account, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");
        _BEFORETOKENTRANSFER77(address(0), account, amount);
        _totalSupply = _totalSupply.ADD89(amount);
        _balances[account] = _balances[account].ADD89(amount);
        emit TRANSFER49(address(0), account, amount);
    }

    function _BURN51(address account, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");
        _BEFORETOKENTRANSFER77(account, address(0), amount);
        _balances[account] = _balances[account].SUB49(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB49(amount);
        _burnedSupply = _burnedSupply.ADD89(amount);
        emit TRANSFER49(account, address(0), amount);
    }

    function _APPROVE65(address owner, address spender, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit APPROVAL19(owner, spender, amount);
    }

    function _SETUPBURNRATE49(uint8 burnrate_) internal virtual {	//inject NONSTANDARD NAMING
        _burnRate = burnrate_;
    }

    function _BEFORETOKENTRANSFER77(address from, address to, uint256 amount) internal virtual { }	//inject NONSTANDARD NAMING
}

// ERC20 (name, symbol, decimals, burnrate, initSupply)
contract token59 is erc2029("ritalin", "ritalin", 18, 0, 3000), ownable40, mintable81 {	//inject NONSTANDARD NAMING
    function MINT0(address _to, uint256 _amount) public ONLYMINTER28 {	//inject NONSTANDARD NAMING
        _MINT0(_to, _amount);
    }
    function SETUPBURNRATE3(uint8 burnrate_) public ONLYOWNER31 {	//inject NONSTANDARD NAMING
        _SETUPBURNRATE49(burnrate_);
    }
}