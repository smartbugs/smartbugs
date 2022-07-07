                                                                 

pragma solidity 0.6.12;

abstract contract Context {
    function _MSGSENDER728() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA416() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

library SafeMath {
    
    function ADD234(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB700(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB700(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB700(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL434(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV517(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV517(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV517(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD216(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD216(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD216(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT556(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function SENDVALUE475(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function FUNCTIONCALL757(address target, bytes memory data) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALL757(target, data, "Address: low-level call failed");
    }

                                                                                                                                                                                                                       
    function FUNCTIONCALL757(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALLWITHVALUE914(target, data, 0, errorMessage);
    }

                                                                                                                                                                                                                                                                                                                                                                   
    function FUNCTIONCALLWITHVALUE914(address target, bytes memory data, uint256 value) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALLWITHVALUE914(target, data, value, "Address: low-level call with value failed");
    }

                                                                                                                                                                                                                                                 
    function FUNCTIONCALLWITHVALUE914(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(ISCONTRACT556(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _VERIFYCALLRESULT588(success, returndata, errorMessage);
    }

                                                                                                                                                                          
    function FUNCTIONSTATICCALL245(address target, bytes memory data) internal view returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONSTATICCALL245(target, data, "Address: low-level static call failed");
    }

                                                                                                                                                                                 
    function FUNCTIONSTATICCALL245(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(ISCONTRACT556(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _VERIFYCALLRESULT588(success, returndata, errorMessage);
    }

                                                                                                                                                                            
    function FUNCTIONDELEGATECALL133(address target, bytes memory data) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONDELEGATECALL133(target, data, "Address: low-level delegate call failed");
    }

                                                                                                                                                                                   
    function FUNCTIONDELEGATECALL133(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(ISCONTRACT556(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _VERIFYCALLRESULT588(success, returndata, errorMessage);
    }

    function _VERIFYCALLRESULT588(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {	//inject NONSTANDARD NAMING
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

                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY180() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF61(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER269(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE441(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE833(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM668(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER122(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL841(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) public _whitelistedAddresses;

    uint256 private _totalSupply;
    uint256 private _burnedSupply;
    uint256 private _minSupply;
    uint256 private _burnRate;
    string private _name;
    string private _symbol;
    uint256 private _decimals;

                                                                                                                                                                                                                                                                                                                           
    constructor (string memory name, string memory symbol, uint256 decimals, uint256 burnrate, uint256 initSupply, uint256 minSupply) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _burnRate = burnrate;
        _totalSupply = 0;
        _MINT6(msg.sender, initSupply*(10**_decimals));
        _burnedSupply = 0;
        _minSupply = minSupply*(10**_decimals);
    }

                                                          
    function NAME393() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

                                                                                                          
    function SYMBOL764() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function DECIMALS776() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _decimals;
    }

                                                     
    function TOTALSUPPLY180() public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                                
    function BURNEDSUPPLY467() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _burnedSupply;
    }
    
    function MINSUPPLY75() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _minSupply;
    }

                                                 
    function BURNRATE206() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _burnRate;
    }

                                                   
    function BALANCEOF61(address account) public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

                                                                                                                                                                                                    
    function TRANSFER269(address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER73(_MSGSENDER728(), recipient, amount);
        return true;
    }

                                                                                                                                                                                                  
    function BURN794(uint256 amount) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _BURN576(_MSGSENDER728(), amount);
        return true;
    }

                                                   
    function ALLOWANCE441(address owner, address spender) public view virtual override returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

                                                                                                                                   
    function APPROVE833(address spender, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE533(_MSGSENDER728(), spender, amount);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function TRANSFERFROM668(address sender, address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER73(sender, recipient, amount);
        _APPROVE533(sender, _MSGSENDER728(), _allowances[sender][_MSGSENDER728()].SUB700(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                    
    function INCREASEALLOWANCE132(address spender, uint256 addedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE533(_MSGSENDER728(), spender, _allowances[_MSGSENDER728()][spender].ADD234(addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DECREASEALLOWANCE166(address spender, uint256 subtractedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE533(_MSGSENDER728(), spender, _allowances[_MSGSENDER728()][spender].SUB700(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function _TRANSFER73(address sender, address recipient, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        if (_whitelistedAddresses[sender] == true || _whitelistedAddresses[recipient] == true) {
            _BEFORETOKENTRANSFER389(sender, recipient, amount);
            _balances[sender] = _balances[sender].SUB700(amount, "ERC20: transfer amount exceeds balance");
            _balances[recipient] = _balances[recipient].ADD234(amount);
            emit TRANSFER122(sender, recipient, amount);
        } else {
            uint256 amount_burn = amount.MUL434(_burnRate).DIV517(1000);
            uint256 amount_send = amount.SUB700(amount_burn);
            require(amount == amount_send + amount_burn, "Burn value invalid");
            if(_totalSupply.SUB700(amount_burn) >= _minSupply) {
                _BURN576(sender, amount_burn);
                amount = amount_send;
            } else {
                amount = amount_send + amount_burn;
            }
            _BEFORETOKENTRANSFER389(sender, recipient, amount);
            _balances[sender] = _balances[sender].SUB700(amount, "ERC20: transfer amount exceeds balance");
            _balances[recipient] = _balances[recipient].ADD234(amount);
            emit TRANSFER122(sender, recipient, amount);
        }
    }

                                                                                                                                                                                                                                                                                                                                                                                                           
    function _MINT6(address account, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");
        _BEFORETOKENTRANSFER389(address(0), account, amount);
        _totalSupply = _totalSupply.ADD234(amount);
        _balances[account] = _balances[account].ADD234(amount);
        emit TRANSFER122(address(0), account, amount);
    }

                                                                                                                                                                                                                                                                                                                        
    function _BURN576(address account, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");
        _BEFORETOKENTRANSFER389(account, address(0), amount);
        _balances[account] = _balances[account].SUB700(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB700(amount);
        _burnedSupply = _burnedSupply.ADD234(amount);
        emit TRANSFER122(account, address(0), amount);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function _APPROVE533(address owner, address spender, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit APPROVAL841(owner, spender, amount);
    }

                                                                                  
    function _SETUPBURNRATE412(uint8 burnrate_) internal virtual {	//inject NONSTANDARD NAMING
        _burnRate = burnrate_;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function _BEFORETOKENTRANSFER389(address from, address to, uint256 amount) internal virtual { }	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
contract Ownable is Context {
    address private _owner;

    event OWNERSHIPTRANSFERRED504(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        address msgSender = _MSGSENDER728();
        _owner = msgSender;
        emit OWNERSHIPTRANSFERRED504(address(0), msgSender);
    }

                                                                     
    function OWNER815() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER650() {	//inject NONSTANDARD NAMING
        require(_owner == _MSGSENDER728(), "Ownable: caller is not the owner");
        _;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP852() public virtual ONLYOWNER650 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED504(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP771(address newOwner) public virtual ONLYOWNER650 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED504(_owner, newOwner);
        _owner = newOwner;
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
contract Mintable is Context {

                                                                                                                                                                                                                                                                                                                  
    address private _minter;

    event MINTERSHIPTRANSFERRED804(address indexed previousMinter, address indexed newMinter);	//inject NONSTANDARD NAMING

                                                                                                
    constructor () internal {
        address msgSender = _MSGSENDER728();
        _minter = msgSender;
        emit MINTERSHIPTRANSFERRED804(address(0), msgSender);
    }

                                                                      
    function MINTER10() public view returns (address) {	//inject NONSTANDARD NAMING
        return _minter;
    }

                                                                                  
    modifier ONLYMINTER693() {	//inject NONSTANDARD NAMING
        require(_minter == _MSGSENDER728(), "Mintable: caller is not the minter");
        _;
    }

                                                                                                                                                 
    function TRANSFERMINTERSHIP415(address newMinter) public virtual ONLYMINTER693 {	//inject NONSTANDARD NAMING
        require(newMinter != address(0), "Mintable: new minter is the zero address");
        emit MINTERSHIPTRANSFERRED804(_minter, newMinter);
        _minter = newMinter;
    }
}

contract DopeSwap is ERC20("DopeSwap", "DOPE", 18, 25, 1000, 500), Ownable, Mintable {
                                                                                                 
    function MINT901(address _to, uint256 _amount) public ONLYMINTER693 {	//inject NONSTANDARD NAMING
        _MINT6(_to, _amount);
    }

    function SETBURNRATE116(uint8 burnrate_) public ONLYOWNER650 {	//inject NONSTANDARD NAMING
        _SETUPBURNRATE412(burnrate_);
    }

    function ADDWHITELISTEDADDRESS905(address _address) public ONLYOWNER650 {	//inject NONSTANDARD NAMING
        _whitelistedAddresses[_address] = true;
    }

    function REMOVEWHITELISTEDADDRESS470(address _address) public ONLYOWNER650 {	//inject NONSTANDARD NAMING
        _whitelistedAddresses[_address] = false;
    }
}