                                                                 

                                                                                                                 

pragma solidity ^0.6.12;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
abstract contract context10 {	//inject NONSTANDARD NAMING
    function _MSGSENDER9() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA1() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

                                                                      
interface ierc202 {	//inject NONSTANDARD NAMING
                                                                      
    function TOTALSUPPLY1() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF3(address ACCOUNT10) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER5(address RECIPIENT5, uint256 AMOUNT9) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE1(address OWNER0, address SPENDER5) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE1(address SPENDER5, uint256 AMOUNT9) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM10(address SENDER1, address RECIPIENT5, uint256 AMOUNT9) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER2(address indexed FROM2, address indexed TO9, uint256 VALUE2);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL10(address indexed OWNER0, address indexed SPENDER5, uint256 VALUE2);	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library safemath1 {	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                    
    function ADD4(uint256 A1, uint256 B6) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 C8 = A1 + B6;	//inject NONSTANDARD NAMING
        require(C8 >= A1, "SafeMath: addition overflow");

        return C8;
    }

                                                                                                                                                                                                                                                                        
    function SUB5(uint256 A1, uint256 B6) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB5(A1, B6, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB5(uint256 A1, uint256 B6, string memory ERRORMESSAGE3) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(B6 <= A1, ERRORMESSAGE3);
        uint256 C8 = A1 - B6;	//inject NONSTANDARD NAMING

        return C8;
    }

                                                                                                                                                                                                                                                
    function MUL6(uint256 A1, uint256 B6) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (A1 == 0) {
            return 0;
        }

        uint256 C8 = A1 * B6;	//inject NONSTANDARD NAMING
        require(C8 / A1 == B6, "SafeMath: multiplication overflow");

        return C8;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV4(uint256 A1, uint256 B6) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV4(A1, B6, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV4(uint256 A1, uint256 B6, string memory ERRORMESSAGE3) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(B6 > 0, ERRORMESSAGE3);
        uint256 C8 = A1 / B6;	//inject NONSTANDARD NAMING
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return C8;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD8(uint256 A1, uint256 B6) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD8(A1, B6, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD8(uint256 A1, uint256 B6, string memory ERRORMESSAGE3) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(B6 != 0, ERRORMESSAGE3);
        return A1 % B6;
    }
}


                                                                   
library address5 {	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT2(address ACCOUNT10) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 CODEHASH4;	//inject NONSTANDARD NAMING
        bytes32 ACCOUNTHASH1 = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;	//inject NONSTANDARD NAMING
        // solhint-disable-next-line no-inline-assembly
        assembly { CODEHASH4 := extcodehash(ACCOUNT10) }
        return (CODEHASH4 != ACCOUNTHASH1 && CODEHASH4 != 0x0);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function SENDVALUE0(address payable RECIPIENT5, uint256 AMOUNT9) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= AMOUNT9, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool SUCCESS3, ) = RECIPIENT5.call{ value: AMOUNT9 }("");	//inject NONSTANDARD NAMING
        require(SUCCESS3, "Address: unable to send value, recipient may have reverted");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function FUNCTIONCALL5(address TARGET4, bytes memory DATA2) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
      return FUNCTIONCALL5(TARGET4, DATA2, "Address: low-level call failed");
    }

                                                                                                                                                                                                                       
    function FUNCTIONCALL5(address TARGET4, bytes memory DATA2, string memory ERRORMESSAGE3) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _FUNCTIONCALLWITHVALUE9(TARGET4, DATA2, 0, ERRORMESSAGE3);
    }

                                                                                                                                                                                                                                                                                                                                                                   
    function FUNCTIONCALLWITHVALUE5(address TARGET4, bytes memory DATA2, uint256 VALUE2) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALLWITHVALUE5(TARGET4, DATA2, VALUE2, "Address: low-level call with value failed");
    }

                                                                                                                                                                                                                                                 
    function FUNCTIONCALLWITHVALUE5(address TARGET4, bytes memory DATA2, uint256 VALUE2, string memory ERRORMESSAGE3) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(address(this).balance >= VALUE2, "Address: insufficient balance for call");
        return _FUNCTIONCALLWITHVALUE9(TARGET4, DATA2, VALUE2, ERRORMESSAGE3);
    }

    function _FUNCTIONCALLWITHVALUE9(address TARGET4, bytes memory DATA2, uint256 WEIVALUE7, string memory ERRORMESSAGE3) private returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(ISCONTRACT2(TARGET4), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool SUCCESS3, bytes memory RETURNDATA9) = TARGET4.call{ value: WEIVALUE7 }(DATA2);	//inject NONSTANDARD NAMING
        if (SUCCESS3) {
            return RETURNDATA9;
        } else {
            // Look for revert reason and bubble it up if present
            if (RETURNDATA9.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(RETURNDATA9)
                    revert(add(32, RETURNDATA9), returndata_size)
                }
            } else {
                revert(ERRORMESSAGE3);
            }
        }
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
library safeerc206 {	//inject NONSTANDARD NAMING
    using safemath1 for uint256;
    using address5 for address;

    function SAFETRANSFER10(ierc202 TOKEN0, address TO9, uint256 VALUE2) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN7(TOKEN0, abi.encodeWithSelector(TOKEN0.TRANSFER5.selector, TO9, VALUE2));
    }

    function SAFETRANSFERFROM2(ierc202 TOKEN0, address FROM2, address TO9, uint256 VALUE2) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN7(TOKEN0, abi.encodeWithSelector(TOKEN0.TRANSFERFROM10.selector, FROM2, TO9, VALUE2));
    }

                                                                                                                                                                                                                                                             
    function SAFEAPPROVE2(ierc202 TOKEN0, address SPENDER5, uint256 VALUE2) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((VALUE2 == 0) || (TOKEN0.ALLOWANCE1(address(this), SPENDER5) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _CALLOPTIONALRETURN7(TOKEN0, abi.encodeWithSelector(TOKEN0.APPROVE1.selector, SPENDER5, VALUE2));
    }

    function SAFEINCREASEALLOWANCE0(ierc202 TOKEN0, address SPENDER5, uint256 VALUE2) internal {	//inject NONSTANDARD NAMING
        uint256 NEWALLOWANCE4 = TOKEN0.ALLOWANCE1(address(this), SPENDER5).ADD4(VALUE2);	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN7(TOKEN0, abi.encodeWithSelector(TOKEN0.APPROVE1.selector, SPENDER5, NEWALLOWANCE4));
    }

    function SAFEDECREASEALLOWANCE7(ierc202 TOKEN0, address SPENDER5, uint256 VALUE2) internal {	//inject NONSTANDARD NAMING
        uint256 NEWALLOWANCE4 = TOKEN0.ALLOWANCE1(address(this), SPENDER5).SUB5(VALUE2, "SafeERC20: decreased allowance below zero");	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN7(TOKEN0, abi.encodeWithSelector(TOKEN0.APPROVE1.selector, SPENDER5, NEWALLOWANCE4));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function _CALLOPTIONALRETURN7(ierc202 TOKEN0, bytes memory DATA2) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory RETURNDATA9 = address(TOKEN0).FUNCTIONCALL5(DATA2, "SafeERC20: low-level call failed");	//inject NONSTANDARD NAMING
        if (RETURNDATA9.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(RETURNDATA9, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}



                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
contract ownable2 is context10 {	//inject NONSTANDARD NAMING
    address private _OWNER5;	//inject NONSTANDARD NAMING

    event OWNERSHIPTRANSFERRED2(address indexed PREVIOUSOWNER0, address indexed NEWOWNER9);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        address MSGSENDER1 = _MSGSENDER9();	//inject NONSTANDARD NAMING
        _OWNER5 = MSGSENDER1;
        emit OWNERSHIPTRANSFERRED2(address(0), MSGSENDER1);
    }

                                                                     
    function OWNER2() public view returns (address) {	//inject NONSTANDARD NAMING
        return _OWNER5;
    }

                                                                                 
    modifier ONLYOWNER10() {	//inject NONSTANDARD NAMING
        require(_OWNER5 == _MSGSENDER9(), "Ownable: caller is not the owner");
        _;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP2() public virtual ONLYOWNER10 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED2(_OWNER5, address(0));
        _OWNER5 = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP5(address NEWOWNER9) public virtual ONLYOWNER10 {	//inject NONSTANDARD NAMING
        require(NEWOWNER9 != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED2(_OWNER5, NEWOWNER9);
        _OWNER5 = NEWOWNER9;
    }
}


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
contract erc206 is context10, ierc202 {	//inject NONSTANDARD NAMING
    using safemath1 for uint256;
    using address5 for address;

    mapping (address => uint256) private _BALANCES2;	//inject NONSTANDARD NAMING

    mapping (address => mapping (address => uint256)) private _ALLOWANCES8;	//inject NONSTANDARD NAMING

    uint256 private _TOTALSUPPLY10;	//inject NONSTANDARD NAMING

    string private _NAME6;	//inject NONSTANDARD NAMING
    string private _SYMBOL5;	//inject NONSTANDARD NAMING
    uint8 private _DECIMALS1;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                           
    constructor (string memory NAME8, string memory SYMBOL9) public {	//inject NONSTANDARD NAMING
        _NAME6 = NAME8;
        _SYMBOL5 = SYMBOL9;
        _DECIMALS1 = 18;
    }

                                                          
    function NAME2() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _NAME6;
    }

                                                                                                          
    function SYMBOL4() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _SYMBOL5;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function DECIMALS0() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _DECIMALS1;
    }

                                                     
    function TOTALSUPPLY1() public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _TOTALSUPPLY10;
    }

                                                   
    function BALANCEOF3(address ACCOUNT10) public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _BALANCES2[ACCOUNT10];
    }

                                                                                                                                                                                                    
    function TRANSFER5(address RECIPIENT5, uint256 AMOUNT9) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER10(_MSGSENDER9(), RECIPIENT5, AMOUNT9);
        return true;
    }

                                                   
    function ALLOWANCE1(address OWNER0, address SPENDER5) public view virtual override returns (uint256) {	//inject NONSTANDARD NAMING
        return _ALLOWANCES8[OWNER0][SPENDER5];
    }

                                                                                                                                   
    function APPROVE1(address SPENDER5, uint256 AMOUNT9) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE0(_MSGSENDER9(), SPENDER5, AMOUNT9);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function TRANSFERFROM10(address SENDER1, address RECIPIENT5, uint256 AMOUNT9) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER10(SENDER1, RECIPIENT5, AMOUNT9);
        _APPROVE0(SENDER1, _MSGSENDER9(), _ALLOWANCES8[SENDER1][_MSGSENDER9()].SUB5(AMOUNT9, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                    
    function INCREASEALLOWANCE2(address SPENDER5, uint256 ADDEDVALUE8) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE0(_MSGSENDER9(), SPENDER5, _ALLOWANCES8[_MSGSENDER9()][SPENDER5].ADD4(ADDEDVALUE8));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DECREASEALLOWANCE5(address SPENDER5, uint256 SUBTRACTEDVALUE10) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE0(_MSGSENDER9(), SPENDER5, _ALLOWANCES8[_MSGSENDER9()][SPENDER5].SUB5(SUBTRACTEDVALUE10, "ERC20: decreased allowance below zero"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function _TRANSFER10(address SENDER1, address RECIPIENT5, uint256 AMOUNT9) internal virtual {	//inject NONSTANDARD NAMING
        require(SENDER1 != address(0), "ERC20: transfer from the zero address");
        require(RECIPIENT5 != address(0), "ERC20: transfer to the zero address");

        _BEFORETOKENTRANSFER8(SENDER1, RECIPIENT5, AMOUNT9);

        _BALANCES2[SENDER1] = _BALANCES2[SENDER1].SUB5(AMOUNT9, "ERC20: transfer amount exceeds balance");
        _BALANCES2[RECIPIENT5] = _BALANCES2[RECIPIENT5].ADD4(AMOUNT9);
        emit TRANSFER2(SENDER1, RECIPIENT5, AMOUNT9);
    }

                                                                                                                                                                                                                                                                       
    function _MINT10(address ACCOUNT10, uint256 AMOUNT9) internal virtual {	//inject NONSTANDARD NAMING
        require(ACCOUNT10 != address(0), "ERC20: mint to the zero address");

        _BEFORETOKENTRANSFER8(address(0), ACCOUNT10, AMOUNT9);

        _TOTALSUPPLY10 = _TOTALSUPPLY10.ADD4(AMOUNT9);
        _BALANCES2[ACCOUNT10] = _BALANCES2[ACCOUNT10].ADD4(AMOUNT9);
        emit TRANSFER2(address(0), ACCOUNT10, AMOUNT9);
    }

                                                                                                                                                                                                                                                                                                                        
    function _BURN5(address ACCOUNT10, uint256 AMOUNT9) internal virtual {	//inject NONSTANDARD NAMING
        require(ACCOUNT10 != address(0), "ERC20: burn from the zero address");

        _BEFORETOKENTRANSFER8(ACCOUNT10, address(0), AMOUNT9);

        _BALANCES2[ACCOUNT10] = _BALANCES2[ACCOUNT10].SUB5(AMOUNT9, "ERC20: burn amount exceeds balance");
        _TOTALSUPPLY10 = _TOTALSUPPLY10.SUB5(AMOUNT9);
        emit TRANSFER2(ACCOUNT10, address(0), AMOUNT9);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function _APPROVE0(address OWNER0, address SPENDER5, uint256 AMOUNT9) internal virtual {	//inject NONSTANDARD NAMING
        require(OWNER0 != address(0), "ERC20: approve from the zero address");
        require(SPENDER5 != address(0), "ERC20: approve to the zero address");

        _ALLOWANCES8[OWNER0][SPENDER5] = AMOUNT9;
        emit APPROVAL10(OWNER0, SPENDER5, AMOUNT9);
    }

                                                                                                                                                                                                                                                                                                                            
    function _SETUPDECIMALS6(uint8 DECIMALS_1) internal {	//inject NONSTANDARD NAMING
        _DECIMALS1 = DECIMALS_1;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function _BEFORETOKENTRANSFER8(address FROM2, address TO9, uint256 AMOUNT9) internal virtual { }	//inject NONSTANDARD NAMING
}

// Moon Token with Governance.
contract moontoken3 is erc206("MOON.finance", "MOON"), ownable2 {	//inject NONSTANDARD NAMING
                                                                                             
    function MINT7(address _TO2, uint256 _AMOUNT3) public ONLYOWNER10 {	//inject NONSTANDARD NAMING
        _MINT10(_TO2, _AMOUNT3);
    }
}