                                                                 

pragma solidity ^0.6.0;


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
contract initializable5 {	//inject NONSTANDARD NAMING

                                                                       
  bool private initialized;

                                                                                         
  bool private initializing;

                                                                                
  modifier INITIALIZER65() {	//inject NONSTANDARD NAMING
    require(initializing || ISCONSTRUCTOR91() || !initialized, "Contract instance has already been initialized");

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

                                                                                 
  function ISCONSTRUCTOR91() private view returns (bool) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
contract contextupgradesafe87 is initializable5 {	//inject NONSTANDARD NAMING
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.

    function __CONTEXT_INIT10() internal INITIALIZER65 {	//inject NONSTANDARD NAMING
        __CONTEXT_INIT_UNCHAINED61();
    }

    function __CONTEXT_INIT_UNCHAINED61() internal INITIALIZER65 {	//inject NONSTANDARD NAMING


    }


    function _MSGSENDER78() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA22() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }

    uint256[50] private __gap;
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
contract ownableupgradesafe25 is initializable5, contextupgradesafe87 {	//inject NONSTANDARD NAMING
    address private _owner;

    event OWNERSHIPTRANSFERRED52(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               

    function __OWNABLE_INIT13() internal INITIALIZER65 {	//inject NONSTANDARD NAMING
        __CONTEXT_INIT_UNCHAINED61();
        __OWNABLE_INIT_UNCHAINED84();
    }

    function __OWNABLE_INIT_UNCHAINED84() internal INITIALIZER65 {	//inject NONSTANDARD NAMING


        address msgSender = _MSGSENDER78();
        _owner = msgSender;
        emit OWNERSHIPTRANSFERRED52(address(0), msgSender);

    }


                                                                     
    function OWNER9() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER81() {	//inject NONSTANDARD NAMING
        require(_owner == _MSGSENDER78(), "Ownable: caller is not the owner");
        _;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP19() public virtual ONLYOWNER81 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED52(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP24(address newOwner) public virtual ONLYOWNER81 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED52(_owner, newOwner);
        _owner = newOwner;
    }

    uint256[49] private __gap;
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library safemath14 {	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                             
    function ADD80(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB60(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB60(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                     
    function SUB60(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL16(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV54(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV54(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function DIV54(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD56(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD56(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function MOD56(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

                                                                      
interface ierc2086 {	//inject NONSTANDARD NAMING
                                                                      
    function TOTALSUPPLY25() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF21(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER6(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE84(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE33(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM54(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER56(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL90(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

library console87 {	//inject NONSTANDARD NAMING
	address constant console_address36 = address(0x000000000000000000636F6e736F6c652e6c6f67);	//inject NONSTANDARD NAMING

	function _SENDLOGPAYLOAD51(bytes memory payload) private view {	//inject NONSTANDARD NAMING
		uint256 payloadLength = payload.length;
		address consoleAddress = console_address36;
		assembly {
			let payloadStart := add(payload, 32)
			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
		}
	}

	function LOG40() internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log()"));
	}

	function LOGINT64(int p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(int)", p0));
	}

	function LOGUINT96(uint p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint)", p0));
	}

	function LOGSTRING94(string memory p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string)", p0));
	}

	function LOGBOOL52(bool p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool)", p0));
	}

	function LOGADDRESS2(address p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address)", p0));
	}

	function LOGBYTES0(bytes memory p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes)", p0));
	}

	function LOGBYTE23(byte p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(byte)", p0));
	}

	function LOGBYTES1100(bytes1 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes1)", p0));
	}

	function LOGBYTES273(bytes2 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes2)", p0));
	}

	function LOGBYTES377(bytes3 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes3)", p0));
	}

	function LOGBYTES477(bytes4 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes4)", p0));
	}

	function LOGBYTES578(bytes5 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes5)", p0));
	}

	function LOGBYTES61(bytes6 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes6)", p0));
	}

	function LOGBYTES735(bytes7 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes7)", p0));
	}

	function LOGBYTES818(bytes8 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes8)", p0));
	}

	function LOGBYTES931(bytes9 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes9)", p0));
	}

	function LOGBYTES1064(bytes10 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes10)", p0));
	}

	function LOGBYTES1141(bytes11 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes11)", p0));
	}

	function LOGBYTES1261(bytes12 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes12)", p0));
	}

	function LOGBYTES1365(bytes13 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes13)", p0));
	}

	function LOGBYTES1433(bytes14 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes14)", p0));
	}

	function LOGBYTES1532(bytes15 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes15)", p0));
	}

	function LOGBYTES1678(bytes16 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes16)", p0));
	}

	function LOGBYTES176(bytes17 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes17)", p0));
	}

	function LOGBYTES1833(bytes18 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes18)", p0));
	}

	function LOGBYTES1973(bytes19 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes19)", p0));
	}

	function LOGBYTES202(bytes20 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes20)", p0));
	}

	function LOGBYTES2137(bytes21 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes21)", p0));
	}

	function LOGBYTES2248(bytes22 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes22)", p0));
	}

	function LOGBYTES2317(bytes23 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes23)", p0));
	}

	function LOGBYTES2438(bytes24 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes24)", p0));
	}

	function LOGBYTES2548(bytes25 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes25)", p0));
	}

	function LOGBYTES261(bytes26 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes26)", p0));
	}

	function LOGBYTES2793(bytes27 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes27)", p0));
	}

	function LOGBYTES2869(bytes28 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes28)", p0));
	}

	function LOGBYTES299(bytes29 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes29)", p0));
	}

	function LOGBYTES3053(bytes30 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes30)", p0));
	}

	function LOGBYTES3139(bytes31 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes31)", p0));
	}

	function LOGBYTES3263(bytes32 p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bytes32)", p0));
	}

	function LOG40(uint p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint)", p0));
	}

	function LOG40(string memory p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string)", p0));
	}

	function LOG40(bool p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool)", p0));
	}

	function LOG40(address p0) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address)", p0));
	}

	function LOG40(uint p0, uint p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint)", p0, p1));
	}

	function LOG40(uint p0, string memory p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string)", p0, p1));
	}

	function LOG40(uint p0, bool p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool)", p0, p1));
	}

	function LOG40(uint p0, address p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address)", p0, p1));
	}

	function LOG40(string memory p0, uint p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint)", p0, p1));
	}

	function LOG40(string memory p0, string memory p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string)", p0, p1));
	}

	function LOG40(string memory p0, bool p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool)", p0, p1));
	}

	function LOG40(string memory p0, address p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address)", p0, p1));
	}

	function LOG40(bool p0, uint p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint)", p0, p1));
	}

	function LOG40(bool p0, string memory p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string)", p0, p1));
	}

	function LOG40(bool p0, bool p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool)", p0, p1));
	}

	function LOG40(bool p0, address p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address)", p0, p1));
	}

	function LOG40(address p0, uint p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint)", p0, p1));
	}

	function LOG40(address p0, string memory p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string)", p0, p1));
	}

	function LOG40(address p0, bool p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool)", p0, p1));
	}

	function LOG40(address p0, address p1) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address)", p0, p1));
	}

	function LOG40(uint p0, uint p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
	}

	function LOG40(uint p0, uint p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
	}

	function LOG40(uint p0, uint p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
	}

	function LOG40(uint p0, uint p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
	}

	function LOG40(uint p0, string memory p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
	}

	function LOG40(uint p0, string memory p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
	}

	function LOG40(uint p0, string memory p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
	}

	function LOG40(uint p0, string memory p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
	}

	function LOG40(uint p0, bool p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
	}

	function LOG40(uint p0, bool p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
	}

	function LOG40(uint p0, bool p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
	}

	function LOG40(uint p0, bool p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
	}

	function LOG40(uint p0, address p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
	}

	function LOG40(uint p0, address p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
	}

	function LOG40(uint p0, address p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
	}

	function LOG40(uint p0, address p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
	}

	function LOG40(string memory p0, uint p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
	}

	function LOG40(string memory p0, uint p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
	}

	function LOG40(string memory p0, uint p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
	}

	function LOG40(string memory p0, uint p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
	}

	function LOG40(string memory p0, string memory p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
	}

	function LOG40(string memory p0, string memory p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
	}

	function LOG40(string memory p0, string memory p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
	}

	function LOG40(string memory p0, string memory p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
	}

	function LOG40(string memory p0, bool p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
	}

	function LOG40(string memory p0, bool p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
	}

	function LOG40(string memory p0, bool p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
	}

	function LOG40(string memory p0, bool p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
	}

	function LOG40(string memory p0, address p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
	}

	function LOG40(string memory p0, address p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
	}

	function LOG40(string memory p0, address p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
	}

	function LOG40(string memory p0, address p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
	}

	function LOG40(bool p0, uint p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
	}

	function LOG40(bool p0, uint p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
	}

	function LOG40(bool p0, uint p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
	}

	function LOG40(bool p0, uint p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
	}

	function LOG40(bool p0, string memory p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
	}

	function LOG40(bool p0, string memory p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
	}

	function LOG40(bool p0, string memory p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
	}

	function LOG40(bool p0, string memory p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
	}

	function LOG40(bool p0, bool p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
	}

	function LOG40(bool p0, bool p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
	}

	function LOG40(bool p0, bool p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
	}

	function LOG40(bool p0, bool p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
	}

	function LOG40(bool p0, address p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
	}

	function LOG40(bool p0, address p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
	}

	function LOG40(bool p0, address p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
	}

	function LOG40(bool p0, address p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
	}

	function LOG40(address p0, uint p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
	}

	function LOG40(address p0, uint p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
	}

	function LOG40(address p0, uint p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
	}

	function LOG40(address p0, uint p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
	}

	function LOG40(address p0, string memory p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
	}

	function LOG40(address p0, string memory p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
	}

	function LOG40(address p0, string memory p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
	}

	function LOG40(address p0, string memory p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
	}

	function LOG40(address p0, bool p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
	}

	function LOG40(address p0, bool p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
	}

	function LOG40(address p0, bool p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
	}

	function LOG40(address p0, bool p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
	}

	function LOG40(address p0, address p1, uint p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
	}

	function LOG40(address p0, address p1, string memory p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
	}

	function LOG40(address p0, address p1, bool p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
	}

	function LOG40(address p0, address p1, address p2) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
	}

	function LOG40(uint p0, uint p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, uint p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, uint p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, uint p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, uint p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, uint p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, uint p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, uint p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, uint p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, uint p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, uint p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, uint p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, uint p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, uint p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, uint p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, uint p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, string memory p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, bool p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(uint p0, address p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, uint p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, string memory p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, bool p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(string memory p0, address p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, uint p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, string memory p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, bool p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(bool p0, address p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, uint p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, string memory p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, bool p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, uint p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, uint p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, uint p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, uint p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, string memory p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, string memory p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, string memory p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, string memory p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, bool p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, bool p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, bool p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, bool p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, address p2, uint p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, address p2, string memory p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, address p2, bool p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
	}

	function LOG40(address p0, address p1, address p2, address p3) internal view {	//inject NONSTANDARD NAMING
		_SENDLOGPAYLOAD51(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
	}

}

interface iuniswapv2factory11 {	//inject NONSTANDARD NAMING
    event PAIRCREATED16(address indexed token0, address indexed token1, address pair, uint);	//inject NONSTANDARD NAMING

    function FEETO47() external view returns (address);	//inject NONSTANDARD NAMING
    function FEETOSETTER62() external view returns (address);	//inject NONSTANDARD NAMING

    function GETPAIR25(address tokenA, address tokenB) external view returns (address pair);	//inject NONSTANDARD NAMING
    function ALLPAIRS78(uint) external view returns (address pair);	//inject NONSTANDARD NAMING
    function ALLPAIRSLENGTH45() external view returns (uint);	//inject NONSTANDARD NAMING

    function CREATEPAIR19(address tokenA, address tokenB) external returns (address pair);	//inject NONSTANDARD NAMING

    function SETFEETO7(address) external;	//inject NONSTANDARD NAMING
    function SETFEETOSETTER93(address) external;	//inject NONSTANDARD NAMING
}

contract feeapprover21 is ownableupgradesafe25 {	//inject NONSTANDARD NAMING
    using safemath14 for uint256;

    function INITIALIZE58(	//inject NONSTANDARD NAMING
        address _NANOCOREAddress,
        address _WETHAddress,
        address _uniswapFactory
    ) public INITIALIZER65 {
        ownableupgradesafe25.__OWNABLE_INIT13();
        nanocoreTokenAddress = _NANOCOREAddress;
        WETHAddress = _WETHAddress;
        tokenUniswapPair = iuniswapv2factory11(_uniswapFactory).GETPAIR25(WETHAddress,nanocoreTokenAddress);
        feePercentX100 = 15;
        paused = false; // We start paused until sync post LGE happens.
    }

    address tokenUniswapPair;
    iuniswapv2factory11 public uniswapFactory;
    address internal WETHAddress;
    address nanocoreTokenAddress;
    address nanocoreVaultAddress;
    uint8 public feePercentX100;  // max 255 = 25.5% artificial clamp
    uint256 public lastTotalSupplyOfLPTokens;
    bool paused;

    // Pausing transfers of the token
    function SETPAUSED71(bool _pause) public ONLYOWNER81 {	//inject NONSTANDARD NAMING
        paused = _pause;
    }

    function SETFEEMULTIPLIER40(uint8 _feeMultiplier) public ONLYOWNER81 {	//inject NONSTANDARD NAMING
        feePercentX100 = _feeMultiplier;
    }

    function SETNANOCOREVAULTADDRESS89(address _nanocoreVaultAddress) public ONLYOWNER81 {	//inject NONSTANDARD NAMING
        nanocoreVaultAddress = _nanocoreVaultAddress;
    }

    function SYNC99() public {	//inject NONSTANDARD NAMING
        uint256 _LPSupplyOfPairTotal = ierc2086(tokenUniswapPair).TOTALSUPPLY25();
        lastTotalSupplyOfLPTokens = _LPSupplyOfPairTotal;
    }

    function CALCULATEAMOUNTSAFTERFEE82(	//inject NONSTANDARD NAMING
        address sender,
        address recipient, // unusued maybe use din future
        uint256 amount
        ) public  returns (uint256 transferToAmount, uint256 transferToFeeDistributorAmount)
        {
            require(paused == false, "FEE APPROVER: Transfers Paused");
            uint256 _LPSupplyOfPairTotal = ierc2086(tokenUniswapPair).TOTALSUPPLY25();


            // console.log("sender is " , sender);
            // console.log("recipient is is " , recipient, 'pair is :', tokenUniswapPair);

            // console.log("Old LP supply", lastTotalSupplyOfLPTokens);
            // console.log("Current LP supply", _LPSupplyOfPairTotal);

            if(sender == tokenUniswapPair)
                require(lastTotalSupplyOfLPTokens <= _LPSupplyOfPairTotal, "Liquidity withdrawals forbidden");

            // console.log('Sender is pair' , sender == tokenUniswapPair);
            // console.log('lastTotalSupplyOfLPTokens <= _LPSupplyOfPairTotal' , lastTotalSupplyOfLPTokens <= _LPSupplyOfPairTotal);

            if(sender == nanocoreVaultAddress  || sender == tokenUniswapPair ) { // Dont have a fee when nanocorevault is sending, or infinite loop
                console87.LOG40("Sending without fee");                       // And when pair is sending ( buys are happening, no tax on it)
                transferToFeeDistributorAmount = 0;
                transferToAmount = amount;
            }
            else {
                console87.LOG40("Normal fee transfer");
                transferToFeeDistributorAmount = amount.MUL16(feePercentX100).DIV54(1000);
                transferToAmount = amount.SUB60(transferToFeeDistributorAmount);
            }


           lastTotalSupplyOfLPTokens = _LPSupplyOfPairTotal;
        }


}