                                                                 

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0-solc-0.7/contracts/utils/EnumerableSet.sol

// SPDX-License-Identifier: MIT


pragma solidity ^0.7.0;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

                                                                                                                                                                   
    function _ADD852(Set storage set, bytes32 value) private returns (bool) {	//inject NONSTANDARD NAMING
        if (!_CONTAINS492(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

                                                                                                                                                                 
    function _REMOVE675(Set storage set, bytes32 value) private returns (bool) {	//inject NONSTANDARD NAMING
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

                                                                          
    function _CONTAINS492(Set storage set, bytes32 value) private view returns (bool) {	//inject NONSTANDARD NAMING
        return set._indexes[value] != 0;
    }

                                                                          
    function _LENGTH742(Set storage set) private view returns (uint256) {	//inject NONSTANDARD NAMING
        return set._values.length;
    }

                                                                                                                                                                                                                                                                                                                                     
    function _AT360(Set storage set, uint256 index) private view returns (bytes32) {	//inject NONSTANDARD NAMING
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

                                                                                                                                                                   
    function ADD146(AddressSet storage set, address value) internal returns (bool) {	//inject NONSTANDARD NAMING
        return _ADD852(set._inner, bytes32(uint256(value)));
    }

                                                                                                                                                                 
    function REMOVE620(AddressSet storage set, address value) internal returns (bool) {	//inject NONSTANDARD NAMING
        return _REMOVE675(set._inner, bytes32(uint256(value)));
    }

                                                                          
    function CONTAINS72(AddressSet storage set, address value) internal view returns (bool) {	//inject NONSTANDARD NAMING
        return _CONTAINS492(set._inner, bytes32(uint256(value)));
    }

                                                                          
    function LENGTH675(AddressSet storage set) internal view returns (uint256) {	//inject NONSTANDARD NAMING
        return _LENGTH742(set._inner);
    }

                                                                                                                                                                                                                                                                                                                                     
    function AT889(AddressSet storage set, uint256 index) internal view returns (address) {	//inject NONSTANDARD NAMING
        return address(uint256(_AT360(set._inner, index)));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

                                                                                                                                                                   
    function ADD146(UintSet storage set, uint256 value) internal returns (bool) {	//inject NONSTANDARD NAMING
        return _ADD852(set._inner, bytes32(value));
    }

                                                                                                                                                                 
    function REMOVE620(UintSet storage set, uint256 value) internal returns (bool) {	//inject NONSTANDARD NAMING
        return _REMOVE675(set._inner, bytes32(value));
    }

                                                                          
    function CONTAINS72(UintSet storage set, uint256 value) internal view returns (bool) {	//inject NONSTANDARD NAMING
        return _CONTAINS492(set._inner, bytes32(value));
    }

                                                                          
    function LENGTH675(UintSet storage set) internal view returns (uint256) {	//inject NONSTANDARD NAMING
        return _LENGTH742(set._inner);
    }

                                                                                                                                                                                                                                                                                                                                     
    function AT889(UintSet storage set, uint256 index) internal view returns (uint256) {	//inject NONSTANDARD NAMING
        return uint256(_AT360(set._inner, index));
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0-solc-0.7/contracts/GSN/Context.sol

// 

pragma solidity ^0.7.0;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
abstract contract Context {
    function _MSGSENDER914() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA708() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0-solc-0.7/contracts/access/AccessControl.sol

// 

pragma solidity ^0.7.0;




                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
abstract contract AccessControl is Context {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Address for address;

    struct RoleData {
        EnumerableSet.AddressSet members;
        bytes32 adminRole;
    }

    mapping (bytes32 => RoleData) private _roles;

    bytes32 public constant default_admin_role935 = 0x00;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                        
    event ROLEADMINCHANGED723(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                          
    event ROLEGRANTED103(bytes32 indexed role, address indexed account, address indexed sender);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                       
    event ROLEREVOKED950(bytes32 indexed role, address indexed account, address indexed sender);	//inject NONSTANDARD NAMING

                                                                                
    function HASROLE117(bytes32 role, address account) public view returns (bool) {	//inject NONSTANDARD NAMING
        return _roles[role].members.CONTAINS72(account);
    }

                                                                                                                                                                 
    function GETROLEMEMBERCOUNT773(bytes32 role) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _roles[role].members.LENGTH675();
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function GETROLEMEMBER894(bytes32 role, uint256 index) public view returns (address) {	//inject NONSTANDARD NAMING
        return _roles[role].members.AT889(index);
    }

                                                                                                                                                                              
    function GETROLEADMIN738(bytes32 role) public view returns (bytes32) {	//inject NONSTANDARD NAMING
        return _roles[role].adminRole;
    }

                                                                                                                                                                                                                                                   
    function GRANTROLE962(bytes32 role, address account) public virtual {	//inject NONSTANDARD NAMING
        require(HASROLE117(_roles[role].adminRole, _MSGSENDER914()), "AccessControl: sender must be an admin to grant");

        _GRANTROLE886(role, account);
    }

                                                                                                                                                                                                                                   
    function REVOKEROLE159(bytes32 role, address account) public virtual {	//inject NONSTANDARD NAMING
        require(HASROLE117(_roles[role].adminRole, _MSGSENDER914()), "AccessControl: sender must be an admin to revoke");

        _REVOKEROLE39(role, account);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function RENOUNCEROLE17(bytes32 role, address account) public virtual {	//inject NONSTANDARD NAMING
        require(account == _MSGSENDER914(), "AccessControl: can only renounce roles for self");

        _REVOKEROLE39(role, account);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function _SETUPROLE488(bytes32 role, address account) internal virtual {	//inject NONSTANDARD NAMING
        _GRANTROLE886(role, account);
    }

                                                                                                                      
    function _SETROLEADMIN697(bytes32 role, bytes32 adminRole) internal virtual {	//inject NONSTANDARD NAMING
        emit ROLEADMINCHANGED723(role, _roles[role].adminRole, adminRole);
        _roles[role].adminRole = adminRole;
    }

    function _GRANTROLE886(bytes32 role, address account) private {	//inject NONSTANDARD NAMING
        if (_roles[role].members.ADD146(account)) {
            emit ROLEGRANTED103(role, account, _MSGSENDER914());
        }
    }

    function _REVOKEROLE39(bytes32 role, address account) private {	//inject NONSTANDARD NAMING
        if (_roles[role].members.REMOVE620(account)) {
            emit ROLEREVOKED950(role, account, _MSGSENDER914());
        }
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0-solc-0.7/contracts/utils/Address.sol

// 

pragma solidity ^0.7.0;

                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT647(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function SENDVALUE238(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function FUNCTIONCALL669(address target, bytes memory data) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
      return FUNCTIONCALL669(target, data, "Address: low-level call failed");
    }

                                                                                                                                                                                                                       
    function FUNCTIONCALL669(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _FUNCTIONCALLWITHVALUE523(target, data, 0, errorMessage);
    }

                                                                                                                                                                                                                                                                                                                                                                   
    function FUNCTIONCALLWITHVALUE570(address target, bytes memory data, uint256 value) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALLWITHVALUE570(target, data, value, "Address: low-level call with value failed");
    }

                                                                                                                                                                                                                                                 
    function FUNCTIONCALLWITHVALUE570(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _FUNCTIONCALLWITHVALUE523(target, data, value, errorMessage);
    }

    function _FUNCTIONCALLWITHVALUE523(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(ISCONTRACT647(target), "Address: call to non-contract");

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

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0-solc-0.7/contracts/math/SafeMath.sol

// 

pragma solidity ^0.7.0;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                                    
    function ADD146(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB570(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB570(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB570(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL634(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV640(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV640(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV640(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD654(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD654(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD654(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0-solc-0.7/contracts/token/ERC20/IERC20.sol

// 

pragma solidity ^0.7.0;

                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY217() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF756(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER622(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE863(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE47(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM568(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER456(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL815(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.2.0-solc-0.7/contracts/token/ERC20/ERC20.sol

// 

pragma solidity ^0.7.0;





                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

                                                                                                                                                                                                                                                                                                                           
    constructor (string memory name, string memory symbol) {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

                                                          
    function NAME91() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

                                                                                                          
    function SYMBOL382() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function DECIMALS96() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }

                                                     
    function TOTALSUPPLY217() public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                   
    function BALANCEOF756(address account) public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

                                                                                                                                                                                                    
    function TRANSFER622(address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER619(_MSGSENDER914(), recipient, amount);
        return true;
    }

                                                   
    function ALLOWANCE863(address owner, address spender) public view virtual override returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

                                                                                                                                   
    function APPROVE47(address spender, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE737(_MSGSENDER914(), spender, amount);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function TRANSFERFROM568(address sender, address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER619(sender, recipient, amount);
        _APPROVE737(sender, _MSGSENDER914(), _allowances[sender][_MSGSENDER914()].SUB570(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                    
    function INCREASEALLOWANCE53(address spender, uint256 addedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE737(_MSGSENDER914(), spender, _allowances[_MSGSENDER914()][spender].ADD146(addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DECREASEALLOWANCE706(address spender, uint256 subtractedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE737(_MSGSENDER914(), spender, _allowances[_MSGSENDER914()][spender].SUB570(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function _TRANSFER619(address sender, address recipient, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _BEFORETOKENTRANSFER428(sender, recipient, amount);

        _balances[sender] = _balances[sender].SUB570(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD146(amount);
        emit TRANSFER456(sender, recipient, amount);
    }

                                                                                                                                                                                                                                                                       
    function _MINT727(address account, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _BEFORETOKENTRANSFER428(address(0), account, amount);

        _totalSupply = _totalSupply.ADD146(amount);
        _balances[account] = _balances[account].ADD146(amount);
        emit TRANSFER456(address(0), account, amount);
    }

                                                                                                                                                                                                                                                                                                                        
    function _BURN562(address account, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _BEFORETOKENTRANSFER428(account, address(0), amount);

        _balances[account] = _balances[account].SUB570(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB570(amount);
        emit TRANSFER456(account, address(0), amount);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                
    function _APPROVE737(address owner, address spender, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL815(owner, spender, amount);
    }

                                                                                                                                                                                                                                                                                                                            
    function _SETUPDECIMALS703(uint8 decimals_) internal {	//inject NONSTANDARD NAMING
        _decimals = decimals_;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function _BEFORETOKENTRANSFER428(address from, address to, uint256 amount) internal virtual { }	//inject NONSTANDARD NAMING
}



                                                                                                                                                                                                                
abstract contract ERC20Burnable is Context, ERC20 {
    using SafeMath for uint256;

                                                                                                      
    function BURN447(uint256 amount) public virtual {	//inject NONSTANDARD NAMING
        _BURN562(_MSGSENDER914(), amount);
    }

                                                                                                                                                                                                                                                                                                           
    function BURNFROM566(address account, uint256 amount) public virtual {	//inject NONSTANDARD NAMING
        uint256 decreasedAllowance = ALLOWANCE863(account, _MSGSENDER914()).SUB570(amount, "ERC20: burn amount exceeds allowance");

        _APPROVE737(account, _MSGSENDER914(), decreasedAllowance);
        _BURN562(account, amount);
    }
}

// File: browser/TokenERC20.sol

// 
pragma solidity ^0.7;



contract Token is ERC20Burnable, AccessControl {
    
    bytes32 public constant minter_role392 = keccak256("MINTER_ROLE");	//inject NONSTANDARD NAMING
    bytes32 public constant burner_role509 = keccak256("BURNER_ROLE");	//inject NONSTANDARD NAMING
    
    constructor (string memory name, string memory symbol) ERC20(name, symbol) {
        _SETUPROLE488(default_admin_role935, _MSGSENDER914());
        _SETUPROLE488(minter_role392, _MSGSENDER914());
        _SETUPROLE488(burner_role509, _MSGSENDER914());
    }
    
    function MINT678(address to, uint256 amount) public {	//inject NONSTANDARD NAMING
        require(HASROLE117(minter_role392, _MSGSENDER914()), "Caller is not a minter");
        _MINT727(to, amount);
    }
    
    function BURN447(uint256 amount) public override {	//inject NONSTANDARD NAMING
        require(HASROLE117(burner_role509, _MSGSENDER914()), "Caller is not a burner");
        super.BURN447(amount);
    }
    
    function BURNFROM566(address account, uint256 amount) public override {	//inject NONSTANDARD NAMING
        require(HASROLE117(burner_role509, _MSGSENDER914()), "Caller is not a burner");
        super.BURNFROM566(account, amount);
    }
    
}

interface IERC20Ops {
    function MINT678(address, uint256) external;	//inject NONSTANDARD NAMING
    function BURNFROM566(address, uint256) external;	//inject NONSTANDARD NAMING
    function DECIMALS96() external view returns (uint8);	//inject NONSTANDARD NAMING
}

contract TokenSwap is AccessControl {
    
    bytes32 public constant whitelisted497 = keccak256("WHITELISTED");	//inject NONSTANDARD NAMING
    
    address public oldToken;
    address public newToken;
    uint8 public decimalsFactor;
    bool public positiveDecimalsFactor;
    
    constructor(address _oldToken, address _newToken){
        oldToken = _oldToken;
        newToken = _newToken;
        uint8 oldTokenDecimals = IERC20Ops(oldToken).DECIMALS96();
        uint8 newTokenDecimals = IERC20Ops(newToken).DECIMALS96();
        if (newTokenDecimals >= oldTokenDecimals){
            decimalsFactor = newTokenDecimals - oldTokenDecimals;
            positiveDecimalsFactor = true;
        }
        else {
            decimalsFactor = oldTokenDecimals - newTokenDecimals;
            positiveDecimalsFactor = false;
        }
        _SETUPROLE488(default_admin_role935, _MSGSENDER914());
        _SETUPROLE488(whitelisted497, _MSGSENDER914());
    }
    
    function WHITELISTED831(address addr) public view returns (bool) {	//inject NONSTANDARD NAMING
        return HASROLE117(whitelisted497, addr);
    } 
    
    function WHITELISTADD908(address[] memory addrs) public {	//inject NONSTANDARD NAMING
        require(HASROLE117(default_admin_role935, _MSGSENDER914()), "Caller is not admin");
        for (uint256 i = 0; i < addrs.length; i++){
            GRANTROLE962(whitelisted497, addrs[i]);
        }
    }
    
    function WHITELISTREMOVE906(address[] memory addrs) public {	//inject NONSTANDARD NAMING
        require(HASROLE117(default_admin_role935, _MSGSENDER914()), "Caller is not admin");
        for (uint256 i = 0; i < addrs.length; i++){
            REVOKEROLE159(whitelisted497, addrs[i]);
        }
    }
    
    function SWAP530(uint256 val) public {	//inject NONSTANDARD NAMING
        require(HASROLE117(whitelisted497, _MSGSENDER914()), "Caller is not whitelisted");
        IERC20Ops(oldToken).BURNFROM566(_MSGSENDER914(), val);
        if (positiveDecimalsFactor) IERC20Ops(newToken).MINT678(_MSGSENDER914(), val * (10 ** decimalsFactor));
        else IERC20Ops(newToken).MINT678(_MSGSENDER914(), val / (10 ** decimalsFactor));
    }
}