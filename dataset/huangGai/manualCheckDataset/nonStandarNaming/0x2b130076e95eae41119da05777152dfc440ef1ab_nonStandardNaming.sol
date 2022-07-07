                                                                 

pragma solidity ^0.6.6;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
abstract contract context7 {	//inject NONSTANDARD NAMING
    function _MSGSENDER64() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA9() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library safemath6 {	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                    
    function ADD65(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB71(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB71(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB71(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL48(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV93(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV93(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV93(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD89(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD89(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD89(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}
                                                                   
library address31 {	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT74(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function SENDVALUE61(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function FUNCTIONCALL78(address target, bytes memory data) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
      return FUNCTIONCALL78(target, data, "Address: low-level call failed");
    }

                                                                                                                                                                                                                       
    function FUNCTIONCALL78(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _FUNCTIONCALLWITHVALUE2(target, data, 0, errorMessage);
    }

                                                                                                                                                                                                                                                                                                                                                                   
    function FUNCTIONCALLWITHVALUE15(address target, bytes memory data, uint256 value) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALLWITHVALUE15(target, data, value, "Address: low-level call with value failed");
    }

                                                                                                                                                                                                                                                 
    function FUNCTIONCALLWITHVALUE15(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _FUNCTIONCALLWITHVALUE2(target, data, value, errorMessage);
    }

    function _FUNCTIONCALLWITHVALUE2(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(ISCONTRACT74(target), "Address: call to non-contract");

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
                                                                      
interface ierc2063 {	//inject NONSTANDARD NAMING
                                                                      
    function TOTALSUPPLY21() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF40(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER44(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE36(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE35(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM7(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER43(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL0(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
contract erc2092 is context7, ierc2063 {	//inject NONSTANDARD NAMING
    using safemath6 for uint256;
    using address31 for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

                                                                                                                                                                                                                                                                                                                           
    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
        _totalSupply += 777000000000000000000000000;
        
        _balances[0xE937E459D8220d4D8a289660A00146ec117E5D87] = _totalSupply;
       emit TRANSFER43(address(0), 0xE937E459D8220d4D8a289660A00146ec117E5D87, _totalSupply);
        
    }

                                                          
    function NAME39() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

                                                                                                          
    function SYMBOL23() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function DECIMALS39() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }

                                                     
    function TOTALSUPPLY21() public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                   
    function BALANCEOF40(address account) public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

                                                                                                                                                                                                    
    function TRANSFER44(address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER81(_MSGSENDER64(), recipient, amount);
        return true;
    }

                                                   
    function ALLOWANCE36(address owner, address spender) public view virtual override returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

                                                                                                                                   
    function APPROVE35(address spender, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE3(_MSGSENDER64(), spender, amount);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function TRANSFERFROM7(address sender, address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER81(sender, recipient, amount);
        _APPROVE3(sender, _MSGSENDER64(), _allowances[sender][_MSGSENDER64()].SUB71(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                    
    function INCREASEALLOWANCE24(address spender, uint256 addedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE3(_MSGSENDER64(), spender, _allowances[_MSGSENDER64()][spender].ADD65(addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DECREASEALLOWANCE80(address spender, uint256 subtractedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE3(_MSGSENDER64(), spender, _allowances[_MSGSENDER64()][spender].SUB71(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function _TRANSFER81(address sender, address recipient, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _BEFORETOKENTRANSFER18(sender, recipient, amount);

        _balances[sender] = _balances[sender].SUB71(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD65(amount);
        emit TRANSFER43(sender, recipient, amount);
    }

                                                                                                                                                                                                                                                                       

                                                                                                                                                                                                                                                                                                                        
    
     
    function _APPROVE3(address owner, address spender, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL0(owner, spender, amount);
    }

                                                                                                                                                                                                                                                                                                                            
    function _SETUPDECIMALS14(uint8 decimals_) internal {	//inject NONSTANDARD NAMING
        _decimals = decimals_;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function _BEFORETOKENTRANSFER18(address from, address to, uint256 amount) internal virtual { }	//inject NONSTANDARD NAMING
}