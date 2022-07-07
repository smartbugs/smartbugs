                                                                 

pragma solidity 0.6.12;


                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY831() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF536(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER353(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE946(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE926(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM954(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER795(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL172(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                             
    function ADD659(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB877(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB877(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                     
    function SUB877(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL487(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV156(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV156(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function DIV156(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD860(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD860(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function MOD860(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT107(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function SENDVALUE513(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER239(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN137(token, abi.encodeWithSelector(token.TRANSFER353.selector, to, value));
    }

    function SAFETRANSFERFROM64(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN137(token, abi.encodeWithSelector(token.TRANSFERFROM954.selector, from, to, value));
    }

    function SAFEAPPROVE765(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.ALLOWANCE946(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _CALLOPTIONALRETURN137(token, abi.encodeWithSelector(token.APPROVE926.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE134(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE946(address(this), spender).ADD659(value);
        _CALLOPTIONALRETURN137(token, abi.encodeWithSelector(token.APPROVE926.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE546(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE946(address(this), spender).SUB877(value, "SafeERC20: decreased allowance below zero");
        _CALLOPTIONALRETURN137(token, abi.encodeWithSelector(token.APPROVE926.selector, spender, newAllowance));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function _CALLOPTIONALRETURN137(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).ISCONTRACT107(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
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

                                                                                                                                                                   
    function _ADD286(Set storage set, bytes32 value) private returns (bool) {	//inject NONSTANDARD NAMING
        if (!_CONTAINS837(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

                                                                                                                                                                 
    function _REMOVE863(Set storage set, bytes32 value) private returns (bool) {	//inject NONSTANDARD NAMING
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

                                                                          
    function _CONTAINS837(Set storage set, bytes32 value) private view returns (bool) {	//inject NONSTANDARD NAMING
        return set._indexes[value] != 0;
    }

                                                                          
    function _LENGTH639(Set storage set) private view returns (uint256) {	//inject NONSTANDARD NAMING
        return set._values.length;
    }

                                                                                                                                                                                                                                                                                                                                     
    function _AT524(Set storage set, uint256 index) private view returns (bytes32) {	//inject NONSTANDARD NAMING
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

                                                                                                                                                                   
    function ADD659(AddressSet storage set, address value) internal returns (bool) {	//inject NONSTANDARD NAMING
        return _ADD286(set._inner, bytes32(uint256(value)));
    }

                                                                                                                                                                 
    function REMOVE976(AddressSet storage set, address value) internal returns (bool) {	//inject NONSTANDARD NAMING
        return _REMOVE863(set._inner, bytes32(uint256(value)));
    }

                                                                          
    function CONTAINS600(AddressSet storage set, address value) internal view returns (bool) {	//inject NONSTANDARD NAMING
        return _CONTAINS837(set._inner, bytes32(uint256(value)));
    }

                                                                          
    function LENGTH659(AddressSet storage set) internal view returns (uint256) {	//inject NONSTANDARD NAMING
        return _LENGTH639(set._inner);
    }

                                                                                                                                                                                                                                                                                                                                     
    function AT450(AddressSet storage set, uint256 index) internal view returns (address) {	//inject NONSTANDARD NAMING
        return address(uint256(_AT524(set._inner, index)));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

                                                                                                                                                                   
    function ADD659(UintSet storage set, uint256 value) internal returns (bool) {	//inject NONSTANDARD NAMING
        return _ADD286(set._inner, bytes32(value));
    }

                                                                                                                                                                 
    function REMOVE976(UintSet storage set, uint256 value) internal returns (bool) {	//inject NONSTANDARD NAMING
        return _REMOVE863(set._inner, bytes32(value));
    }

                                                                          
    function CONTAINS600(UintSet storage set, uint256 value) internal view returns (bool) {	//inject NONSTANDARD NAMING
        return _CONTAINS837(set._inner, bytes32(value));
    }

                                                                          
    function LENGTH659(UintSet storage set) internal view returns (uint256) {	//inject NONSTANDARD NAMING
        return _LENGTH639(set._inner);
    }

                                                                                                                                                                                                                                                                                                                                     
    function AT450(UintSet storage set, uint256 index) internal view returns (uint256) {	//inject NONSTANDARD NAMING
        return uint256(_AT524(set._inner, index));
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
contract Initializable {

                                                                       
  bool private initialized;

                                                                                         
  bool private initializing;

                                                                                
  modifier INITIALIZER933() {	//inject NONSTANDARD NAMING
    require(initializing || ISCONSTRUCTOR543() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

                                                                                 
  function ISCONSTRUCTOR543() private view returns (bool) {	//inject NONSTANDARD NAMING
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
contract ContextUpgradeSafe is Initializable {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.

    function __CONTEXT_INIT408() internal INITIALIZER933 {	//inject NONSTANDARD NAMING
        __CONTEXT_INIT_UNCHAINED28();
    }

    function __CONTEXT_INIT_UNCHAINED28() internal INITIALIZER933 {	//inject NONSTANDARD NAMING


    }


    function _MSGSENDER195() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA356() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }

    uint256[50] private __gap;
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
    address private _owner;

    event OWNERSHIPTRANSFERRED637(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               

    function __OWNABLE_INIT503() internal INITIALIZER933 {	//inject NONSTANDARD NAMING
        __CONTEXT_INIT_UNCHAINED28();
        __OWNABLE_INIT_UNCHAINED19();
    }

    function __OWNABLE_INIT_UNCHAINED19() internal INITIALIZER933 {	//inject NONSTANDARD NAMING


        address msgSender = _MSGSENDER195();
        _owner = msgSender;
        emit OWNERSHIPTRANSFERRED637(address(0), msgSender);

    }


                                                                     
    function OWNER330() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER691() {	//inject NONSTANDARD NAMING
        require(_owner == _MSGSENDER195(), "Ownable: caller is not the owner");
        _;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP236() public virtual ONLYOWNER691 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED637(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP889(address newOwner) public virtual ONLYOWNER691 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED637(_owner, newOwner);
        _owner = newOwner;
    }

    uint256[49] private __gap;
}

                                                                      
interface INBUNIERC20 {
                                                                      
    function TOTALSUPPLY831() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF536(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER353(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE946(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE926(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM954(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER795(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL172(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING


    event LOG470(string log);	//inject NONSTANDARD NAMING

}

library console {
	address constant console_address243 = address(0x000000000000000000636F6e736F6c652e6c6f67);	//inject NONSTANDARD NAMING

	function _SENDLOGPAYLOAD647(bytes memory payload) private view {	//inject NONSTANDARD NAMING
		uint256 payloadLength = payload.length;
		address consoleAddress = console_address243;
		assembly {
			let payloadStart := add(payload, 32)
			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
		}
	}

	function LOG714() internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log()"));
	}

	function LOGINT241(int p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(int)", p0));
	}

	function LOGUINT442(uint p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint)", p0));
	}

	function LOGSTRING55(string memory p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string)", p0));
	}

	function LOGBOOL721(bool p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool)", p0));
	}

	function LOGADDRESS713(address p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address)", p0));
	}

	function LOGBYTES271(bytes memory p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes)", p0));
	}

	function LOGBYTE944(byte p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(byte)", p0));
	}

	function LOGBYTES1701(bytes1 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes1)", p0));
	}

	function LOGBYTES2946(bytes2 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes2)", p0));
	}

	function LOGBYTES314(bytes3 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes3)", p0));
	}

	function LOGBYTES4424(bytes4 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes4)", p0));
	}

	function LOGBYTES566(bytes5 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes5)", p0));
	}

	function LOGBYTES6220(bytes6 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes6)", p0));
	}

	function LOGBYTES7640(bytes7 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes7)", p0));
	}

	function LOGBYTES8995(bytes8 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes8)", p0));
	}

	function LOGBYTES9199(bytes9 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes9)", p0));
	}

	function LOGBYTES10336(bytes10 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes10)", p0));
	}

	function LOGBYTES11706(bytes11 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes11)", p0));
	}

	function LOGBYTES12632(bytes12 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes12)", p0));
	}

	function LOGBYTES13554(bytes13 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes13)", p0));
	}

	function LOGBYTES14593(bytes14 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes14)", p0));
	}

	function LOGBYTES15340(bytes15 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes15)", p0));
	}

	function LOGBYTES16538(bytes16 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes16)", p0));
	}

	function LOGBYTES17699(bytes17 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes17)", p0));
	}

	function LOGBYTES18607(bytes18 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes18)", p0));
	}

	function LOGBYTES19918(bytes19 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes19)", p0));
	}

	function LOGBYTES20388(bytes20 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes20)", p0));
	}

	function LOGBYTES21100(bytes21 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes21)", p0));
	}

	function LOGBYTES22420(bytes22 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes22)", p0));
	}

	function LOGBYTES238(bytes23 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes23)", p0));
	}

	function LOGBYTES24936(bytes24 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes24)", p0));
	}

	function LOGBYTES25750(bytes25 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes25)", p0));
	}

	function LOGBYTES26888(bytes26 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes26)", p0));
	}

	function LOGBYTES2749(bytes27 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes27)", p0));
	}

	function LOGBYTES28446(bytes28 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes28)", p0));
	}

	function LOGBYTES29383(bytes29 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes29)", p0));
	}

	function LOGBYTES30451(bytes30 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes30)", p0));
	}

	function LOGBYTES31456(bytes31 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes31)", p0));
	}

	function LOGBYTES32174(bytes32 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bytes32)", p0));
	}

	function LOG714(uint p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint)", p0));
	}

	function LOG714(string memory p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string)", p0));
	}

	function LOG714(bool p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool)", p0));
	}

	function LOG714(address p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address)", p0));
	}

	function LOG714(uint p0, uint p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint)", p0, p1));
	}

	function LOG714(uint p0, string memory p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string)", p0, p1));
	}

	function LOG714(uint p0, bool p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool)", p0, p1));
	}

	function LOG714(uint p0, address p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address)", p0, p1));
	}

	function LOG714(string memory p0, uint p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint)", p0, p1));
	}

	function LOG714(string memory p0, string memory p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string)", p0, p1));
	}

	function LOG714(string memory p0, bool p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool)", p0, p1));
	}

	function LOG714(string memory p0, address p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address)", p0, p1));
	}

	function LOG714(bool p0, uint p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint)", p0, p1));
	}

	function LOG714(bool p0, string memory p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string)", p0, p1));
	}

	function LOG714(bool p0, bool p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool)", p0, p1));
	}

	function LOG714(bool p0, address p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address)", p0, p1));
	}

	function LOG714(address p0, uint p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint)", p0, p1));
	}

	function LOG714(address p0, string memory p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string)", p0, p1));
	}

	function LOG714(address p0, bool p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool)", p0, p1));
	}

	function LOG714(address p0, address p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address)", p0, p1));
	}

	function LOG714(uint p0, uint p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
	}

	function LOG714(uint p0, uint p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
	}

	function LOG714(uint p0, uint p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
	}

	function LOG714(uint p0, uint p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
	}

	function LOG714(uint p0, string memory p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
	}

	function LOG714(uint p0, string memory p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
	}

	function LOG714(uint p0, string memory p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
	}

	function LOG714(uint p0, string memory p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
	}

	function LOG714(uint p0, bool p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
	}

	function LOG714(uint p0, bool p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
	}

	function LOG714(uint p0, bool p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
	}

	function LOG714(uint p0, bool p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
	}

	function LOG714(uint p0, address p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
	}

	function LOG714(uint p0, address p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
	}

	function LOG714(uint p0, address p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
	}

	function LOG714(uint p0, address p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
	}

	function LOG714(string memory p0, uint p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
	}

	function LOG714(string memory p0, uint p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
	}

	function LOG714(string memory p0, uint p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
	}

	function LOG714(string memory p0, uint p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
	}

	function LOG714(string memory p0, string memory p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
	}

	function LOG714(string memory p0, string memory p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
	}

	function LOG714(string memory p0, string memory p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
	}

	function LOG714(string memory p0, string memory p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
	}

	function LOG714(string memory p0, bool p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
	}

	function LOG714(string memory p0, bool p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
	}

	function LOG714(string memory p0, bool p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
	}

	function LOG714(string memory p0, bool p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
	}

	function LOG714(string memory p0, address p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
	}

	function LOG714(string memory p0, address p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
	}

	function LOG714(string memory p0, address p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
	}

	function LOG714(string memory p0, address p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
	}

	function LOG714(bool p0, uint p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
	}

	function LOG714(bool p0, uint p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
	}

	function LOG714(bool p0, uint p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
	}

	function LOG714(bool p0, uint p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
	}

	function LOG714(bool p0, string memory p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
	}

	function LOG714(bool p0, string memory p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
	}

	function LOG714(bool p0, string memory p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
	}

	function LOG714(bool p0, string memory p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
	}

	function LOG714(bool p0, bool p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
	}

	function LOG714(bool p0, bool p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
	}

	function LOG714(bool p0, bool p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
	}

	function LOG714(bool p0, bool p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
	}

	function LOG714(bool p0, address p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
	}

	function LOG714(bool p0, address p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
	}

	function LOG714(bool p0, address p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
	}

	function LOG714(bool p0, address p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
	}

	function LOG714(address p0, uint p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
	}

	function LOG714(address p0, uint p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
	}

	function LOG714(address p0, uint p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
	}

	function LOG714(address p0, uint p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
	}

	function LOG714(address p0, string memory p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
	}

	function LOG714(address p0, string memory p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
	}

	function LOG714(address p0, string memory p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
	}

	function LOG714(address p0, string memory p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
	}

	function LOG714(address p0, bool p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
	}

	function LOG714(address p0, bool p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
	}

	function LOG714(address p0, bool p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
	}

	function LOG714(address p0, bool p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
	}

	function LOG714(address p0, address p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
	}

	function LOG714(address p0, address p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
	}

	function LOG714(address p0, address p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
	}

	function LOG714(address p0, address p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
	}

	function LOG714(uint p0, uint p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, uint p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, uint p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, uint p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, uint p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, uint p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, uint p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, uint p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, uint p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, uint p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, uint p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, uint p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, uint p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, uint p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, uint p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, uint p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, string memory p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, bool p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(uint p0, address p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, uint p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, string memory p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, bool p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(string memory p0, address p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, uint p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, string memory p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, bool p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(bool p0, address p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, uint p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, string memory p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, bool p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
	}

	function LOG714(address p0, address p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD647(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
	}

}

// HDCore Vault distributes fees equally amongst staked pools
// Have fun reading it. Hopefully it's bug-free. God bless.
contract HdcoreVault is OwnableUpgradeSafe {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // Info of each user.
    struct UserInfo {
        uint256 amount; // How many  tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
        //
        // We do some fancy math here. Basically, any point in time, the amount of HdCOREs
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * pool.accHdcorePerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws  tokens to a pool. Here's what happens:
        //   1. The pool's `accHdcorePerShare` (and `lastRewardBlock`) gets updated.
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.

    }

    // Info of each pool.
    struct PoolInfo {
        IERC20 token; // Address of  token contract.
        uint256 allocPoint; // How many allocation points assigned to this pool. HDCOREs to distribute per block.
        uint256 accHdcorePerShare; // Accumulated HDCOREs per share, times 1e12. See below.
        bool withdrawable; // Is this pool withdrawable?
        mapping(address => mapping(address => uint256)) allowance;

    }

    // The HDCORE TOKEN!
    INBUNIERC20 public hdcore;
    // Dev address.
    address public devaddr;

    // Info of each pool.
    PoolInfo[] public poolInfo;
    // Info of each user that stakes  tokens.
    mapping(uint256 => mapping(address => UserInfo)) public userInfo;
    // Total allocation poitns. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint;

                                                      
    uint256 public pendingRewards;

    uint256 public contractStartBlock;
    uint256 public epochCalculationStartBlock;
    uint256 public cumulativeRewardsSinceStart;
    uint256 public rewardsInThisEpoch;
    uint public epoch;

    // Returns fees generated since start of this contract
    function AVERAGEFEESPERBLOCKSINCESTART533() external view returns (uint averagePerBlock) {	//inject NONSTANDARD NAMING
        averagePerBlock = cumulativeRewardsSinceStart.ADD659(rewardsInThisEpoch).DIV156(block.number.SUB877(contractStartBlock));
    }

    // Returns averge fees in this epoch
    function AVERAGEFEESPERBLOCKEPOCH880() external view returns (uint256 averagePerBlock) {	//inject NONSTANDARD NAMING
        averagePerBlock = rewardsInThisEpoch.DIV156(block.number.SUB877(epochCalculationStartBlock));
    }

    // For easy graphing historical epoch rewards
    mapping(uint => uint256) public epochRewards;

    //Starts a new calculation epoch
    // Because averge since start will not be accurate
    function STARTNEWEPOCH403() public {	//inject NONSTANDARD NAMING
        require(epochCalculationStartBlock + 50000 < block.number, "New epoch not ready yet"); // About a week
        epochRewards[epoch] = rewardsInThisEpoch;
        cumulativeRewardsSinceStart = cumulativeRewardsSinceStart.ADD659(rewardsInThisEpoch);
        rewardsInThisEpoch = 0;
        epochCalculationStartBlock = block.number;
        ++epoch;
    }

    event DEPOSIT941(address indexed user, uint256 indexed pid, uint256 amount);	//inject NONSTANDARD NAMING
    event WITHDRAW483(address indexed user, uint256 indexed pid, uint256 amount);	//inject NONSTANDARD NAMING
    event EMERGENCYWITHDRAW770(	//inject NONSTANDARD NAMING
        address indexed user,
        uint256 indexed pid,
        uint256 amount
    );
    event APPROVAL172(address indexed owner, address indexed spender, uint256 _pid, uint256 value);	//inject NONSTANDARD NAMING


    function INITIALIZE896(	//inject NONSTANDARD NAMING
        INBUNIERC20 _hdcore
    ) public INITIALIZER933 {
        OwnableUpgradeSafe.__OWNABLE_INIT503();
        DEV_FEE = 724;
        hdcore = _hdcore;
        devaddr = msg.sender;
        contractStartBlock = block.number;
        _superAdmin = msg.sender;
    }

    function POOLLENGTH724() external view returns (uint256) {	//inject NONSTANDARD NAMING
        return poolInfo.length;
    }



    // Add a new token pool. Can only be called by the owner.
    // Note contract owner is meant to be a governance contract allowing HDCORE governance consensus
    function ADD659(	//inject NONSTANDARD NAMING
        uint256 _allocPoint,
        IERC20 _token,
        bool _withUpdate,
        bool _withdrawable
    ) public ONLYOWNER691 {
        if (_withUpdate) {
            MASSUPDATEPOOLS941();
        }

        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            require(poolInfo[pid].token != _token,"Error pool already added");
        }

        totalAllocPoint = totalAllocPoint.ADD659(_allocPoint);


        poolInfo.push(
            PoolInfo({
                token: _token,
                allocPoint: _allocPoint,
                accHdcorePerShare: 0,
                withdrawable : _withdrawable
            })
        );
    }

    // Update the given pool's HDCOREs allocation point. Can only be called by the owner.
    // Note contract owner is meant to be a governance contract allowing HDCORE governance consensus

    function SET408(	//inject NONSTANDARD NAMING
        uint256 _pid,
        uint256 _allocPoint,
        bool _withUpdate
    ) public ONLYOWNER691 {
        if (_withUpdate) {
            MASSUPDATEPOOLS941();
        }

        totalAllocPoint = totalAllocPoint.SUB877(poolInfo[_pid].allocPoint).ADD659(
            _allocPoint
        );
        poolInfo[_pid].allocPoint = _allocPoint;
    }

    // Update the given pool's ability to withdraw tokens
    // Note contract owner is meant to be a governance contract allowing HDCORE governance consensus
    function SETPOOLWITHDRAWABLE817(	//inject NONSTANDARD NAMING
        uint256 _pid,
        bool _withdrawable
    ) public ONLYOWNER691 {
        poolInfo[_pid].withdrawable = _withdrawable;
    }



    // Sets the dev fee for this contract
    // defaults at 7.24%
    // Note contract owner is meant to be a governance contract allowing HDCORE governance consensus
    uint16 DEV_FEE;
    function SETDEVFEE755(uint16 _DEV_FEE) public ONLYOWNER691 {	//inject NONSTANDARD NAMING
        require(_DEV_FEE <= 1000, 'Dev fee clamped at 10%');
        DEV_FEE = _DEV_FEE;
    }
    uint256 pending_DEV_rewards;


    // View function to see pending HDCOREs on frontend.
    function PENDINGHDCORE546(uint256 _pid, address _user)	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256)
    {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accHdcorePerShare = pool.accHdcorePerShare;

        return user.amount.MUL487(accHdcorePerShare).DIV156(1e12).SUB877(user.rewardDebt);
    }

    // Update reward vairables for all pools. Be careful of gas spending!
    function MASSUPDATEPOOLS941() public {	//inject NONSTANDARD NAMING
        console.LOG714("Mass Updating Pools");
        uint256 length = poolInfo.length;
        uint allRewards;
        for (uint256 pid = 0; pid < length; ++pid) {
            allRewards = allRewards.ADD659(UPDATEPOOL374(pid));
        }

        pendingRewards = pendingRewards.SUB877(allRewards);
    }

    // ----
    // Function that adds pending rewards, called by the HDCORE token.
    // ----
    uint256 private hdcoreBalance;
    function ADDPENDINGREWARDS319(uint256 _) public {	//inject NONSTANDARD NAMING
        uint256 newRewards = hdcore.BALANCEOF536(address(this)).SUB877(hdcoreBalance);

        if(newRewards > 0) {
            hdcoreBalance = hdcore.BALANCEOF536(address(this)); // If there is no change the balance didn't change
            pendingRewards = pendingRewards.ADD659(newRewards);
            rewardsInThisEpoch = rewardsInThisEpoch.ADD659(newRewards);
        }
    }

    // Update reward variables of the given pool to be up-to-date.
    function UPDATEPOOL374(uint256 _pid) internal returns (uint256 hdcoreRewardWhole) {	//inject NONSTANDARD NAMING
        PoolInfo storage pool = poolInfo[_pid];

        uint256 tokenSupply = pool.token.BALANCEOF536(address(this));
        if (tokenSupply == 0) { // avoids division by 0 errors
            return 0;
        }
        hdcoreRewardWhole = pendingRewards // Multiplies pending rewards by allocation point of this pool and then total allocation
            .MUL487(pool.allocPoint)        // getting the percent of total pending rewards this pool should get
            .DIV156(totalAllocPoint);       // we can do this because pools are only mass updated
        uint256 hdcoreRewardFee = hdcoreRewardWhole.MUL487(DEV_FEE).DIV156(10000);
        uint256 hdcoreRewardToDistribute = hdcoreRewardWhole.SUB877(hdcoreRewardFee);

        pending_DEV_rewards = pending_DEV_rewards.ADD659(hdcoreRewardFee);

        pool.accHdcorePerShare = pool.accHdcorePerShare.ADD659(
            hdcoreRewardToDistribute.MUL487(1e12).DIV156(tokenSupply)
        );

    }

    // Deposit  tokens to HdcoreVault for HDCORE allocation.
    function DEPOSIT767(uint256 _pid, uint256 _amount) public {	//inject NONSTANDARD NAMING

        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];

        MASSUPDATEPOOLS941();

        // Transfer pending tokens
        // to user
        UPDATEANDPAYOUTPENDING193(_pid, pool, user, msg.sender);


        //Transfer in the amounts from user
        // save gas
        if(_amount > 0) {
            pool.token.SAFETRANSFERFROM64(address(msg.sender), address(this), _amount);
            user.amount = user.amount.ADD659(_amount);
        }

        user.rewardDebt = user.amount.MUL487(pool.accHdcorePerShare).DIV156(1e12);
        emit DEPOSIT941(msg.sender, _pid, _amount);
    }

    // Test coverage
    // [x] Does user get the deposited amounts?
    // [x] Does user that its deposited for update correcty?
    // [x] Does the depositor get their tokens decreased
    function DEPOSITFOR318(address depositFor, uint256 _pid, uint256 _amount) public {	//inject NONSTANDARD NAMING
        // requires no allowances
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][depositFor];

        MASSUPDATEPOOLS941();

        // Transfer pending tokens
        // to user
        UPDATEANDPAYOUTPENDING193(_pid, pool, user, depositFor); // Update the balances of person that amount is being deposited for

        if(_amount > 0) {
            pool.token.SAFETRANSFERFROM64(address(msg.sender), address(this), _amount);
            user.amount = user.amount.ADD659(_amount); // This is depositedFor address
        }

        user.rewardDebt = user.amount.MUL487(pool.accHdcorePerShare).DIV156(1e12);                                  
        emit DEPOSIT941(depositFor, _pid, _amount);

    }

    // Test coverage
    // [x] Does allowance update correctly?
    function SETALLOWANCEFORPOOLTOKEN927(address spender, uint256 _pid, uint256 value) public {	//inject NONSTANDARD NAMING
        PoolInfo storage pool = poolInfo[_pid];
        pool.allowance[msg.sender][spender] = value;
        emit APPROVAL172(msg.sender, spender, _pid, value);
    }

    // Test coverage
    // [x] Does allowance decrease?
    // [x] Do oyu need allowance
    // [x] Withdraws to correct address
    function WITHDRAWFROM678(address owner, uint256 _pid, uint256 _amount) public{	//inject NONSTANDARD NAMING

        PoolInfo storage pool = poolInfo[_pid];
        require(pool.allowance[owner][msg.sender] >= _amount, "withdraw: insufficient allowance");
        pool.allowance[owner][msg.sender] = pool.allowance[owner][msg.sender].SUB877(_amount);
        _WITHDRAW26(_pid, _amount, owner, msg.sender);

    }


    // Withdraw  tokens from HdcoreVault.
    function WITHDRAW844(uint256 _pid, uint256 _amount) public {	//inject NONSTANDARD NAMING

        _WITHDRAW26(_pid, _amount, msg.sender, msg.sender);

    }




    // Low level withdraw function
    function _WITHDRAW26(uint256 _pid, uint256 _amount, address from, address to) internal {	//inject NONSTANDARD NAMING
        PoolInfo storage pool = poolInfo[_pid];
        require(pool.withdrawable, "Withdrawing from this pool is disabled");
        UserInfo storage user = userInfo[_pid][from];
        require(user.amount >= _amount, "withdraw: not good");

        MASSUPDATEPOOLS941();
        UPDATEANDPAYOUTPENDING193(_pid,  pool, user, from); // Update balances of from this is not withdrawal but claiming HDCORE farmed

        if(_amount > 0) {
            user.amount = user.amount.SUB877(_amount);
            pool.token.SAFETRANSFER239(address(to), _amount);
        }
        user.rewardDebt = user.amount.MUL487(pool.accHdcorePerShare).DIV156(1e12);

        emit WITHDRAW483(to, _pid, _amount);
    }

    function CLAIM95(uint256 _pid) public {	//inject NONSTANDARD NAMING
        PoolInfo storage pool = poolInfo[_pid];
        require(pool.withdrawable, "Withdrawing from this pool is disabled");
        UserInfo storage user = userInfo[_pid][msg.sender];

        MASSUPDATEPOOLS941();
        UPDATEANDPAYOUTPENDING193(_pid, pool, user, msg.sender);
    }

    function UPDATEANDPAYOUTPENDING193(uint256 _pid, PoolInfo storage pool, UserInfo storage user, address from) internal {	//inject NONSTANDARD NAMING

        if(user.amount == 0) return;

        uint256 pending = user
            .amount
            .MUL487(pool.accHdcorePerShare)
            .DIV156(1e12)
            .SUB877(user.rewardDebt);

        if(pending > 0) {
            SAFEHDCORETRANSFER939(from, pending);
        }

    }

    // function that lets owner/governance contract
    // approve allowance for any token inside this contract
    // This means all future UNI like airdrops are covered
    // And at the same time allows us to give allowance to strategy contracts.
    // Upcoming cYFI etc vaults strategy contracts will use this function to manage and farm yield on value locked
    function SETSTRATEGYCONTRACTORDISTRIBUTIONCONTRACTALLOWANCE131(address tokenAddress, uint256 _amount, address contractAddress) public ONLYSUPERADMIN581 {	//inject NONSTANDARD NAMING
        require(ISCONTRACT107(contractAddress), "Recipent is not a smart contract, BAD");
        require(block.number > contractStartBlock.ADD659(95_000), "Governance setup grace period not over"); // about 2weeks
        IERC20(tokenAddress).APPROVE926(contractAddress, _amount);
    }

    function ISCONTRACT107(address addr) public returns (bool) {	//inject NONSTANDARD NAMING
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }





    // Withdraw without caring about rewards. EMERGENCY ONLY.
    // !Caution this will remove all your pending rewards!
    function EMERGENCYWITHDRAW608(uint256 _pid) public {	//inject NONSTANDARD NAMING
        PoolInfo storage pool = poolInfo[_pid];
        require(pool.withdrawable, "Withdrawing from this pool is disabled");
        UserInfo storage user = userInfo[_pid][msg.sender];
        pool.token.SAFETRANSFER239(address(msg.sender), user.amount);
        emit EMERGENCYWITHDRAW770(msg.sender, _pid, user.amount);
        user.amount = 0;
        user.rewardDebt = 0;
        // No mass update dont update pending rewards
    }

    // Safe hdcore transfer function, just in case if rounding error causes pool to not have enough HDCOREs.
    function SAFEHDCORETRANSFER939(address _to, uint256 _amount) internal {	//inject NONSTANDARD NAMING
        if(_amount == 0) return;

        uint256 hdcoreBal = hdcore.BALANCEOF536(address(this));
        if (_amount > hdcoreBal) {
            console.LOG714("transfering out for to person:", _amount);
            console.LOG714("Balance of this address is :", hdcoreBal);

            hdcore.TRANSFER353(_to, hdcoreBal);
            hdcoreBalance = hdcore.BALANCEOF536(address(this));

        } else {
            hdcore.TRANSFER353(_to, _amount);
            hdcoreBalance = hdcore.BALANCEOF536(address(this));

        }

        if(pending_DEV_rewards > 0) {
            uint256 devSend = pending_DEV_rewards; // Avoid recursive loop
            pending_DEV_rewards = 0;
            SAFEHDCORETRANSFER939(devaddr, devSend);
        }

    }

    // Update dev address by the previous dev.
    // Note onlyOwner functions are meant for the governance contract
    // allowing HDCORE governance token holders to do this functions.
    function SETDEVFEERECIEVER7(address _devaddr) public ONLYOWNER691 {	//inject NONSTANDARD NAMING
        devaddr = _devaddr;
    }



    address private _superAdmin;

    event SUPERADMINTRANSFERED362(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                          
    function SUPERADMIN402() public view returns (address) {	//inject NONSTANDARD NAMING
        return _superAdmin;
    }

                                                                                     
    modifier ONLYSUPERADMIN581() {	//inject NONSTANDARD NAMING
        require(_superAdmin == _MSGSENDER195(), "Super admin : caller is not super admin.");
        _;
    }

    // Assisns super admint to address 0, making it unreachable forever
    function BURNSUPERADMIN143() public virtual ONLYSUPERADMIN581 {	//inject NONSTANDARD NAMING
        emit SUPERADMINTRANSFERED362(_superAdmin, address(0));
        _superAdmin = address(0);
    }

    // Super admin can transfer its powers to another address
    function NEWSUPERADMIN397(address newOwner) public virtual ONLYSUPERADMIN581 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit SUPERADMINTRANSFERED362(_superAdmin, newOwner);
        _superAdmin = newOwner;
    }
}