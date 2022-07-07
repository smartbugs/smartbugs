                                                                 

pragma solidity 0.5.16;

interface ierc207 {	//inject NONSTANDARD NAMING
    function TOTALSUPPLY3() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF6(address ACCOUNT8) external view returns (uint);	//inject NONSTANDARD NAMING
    function TRANSFER0(address RECIPIENT4, uint AMOUNT10) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE8(address OWNER10, address SPENDER9) external view returns (uint);	//inject NONSTANDARD NAMING
    function APPROVE6(address SPENDER9, uint AMOUNT10) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM9(address SENDER7, address RECIPIENT4, uint AMOUNT10) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER10(address indexed FROM9, address indexed TO4, uint VALUE10);	//inject NONSTANDARD NAMING
    event APPROVAL6(address indexed OWNER10, address indexed SPENDER9, uint VALUE10);	//inject NONSTANDARD NAMING
}

contract context1 {	//inject NONSTANDARD NAMING
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER8() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }
}

contract erc209 is context1, ierc207 {	//inject NONSTANDARD NAMING
    using safemath3 for uint;

    mapping (address => uint) private _BALANCES7;	//inject NONSTANDARD NAMING

    mapping (address => mapping (address => uint)) private _ALLOWANCES5;	//inject NONSTANDARD NAMING

    uint private _TOTALSUPPLY10;	//inject NONSTANDARD NAMING
    function TOTALSUPPLY3() public view returns (uint) {	//inject NONSTANDARD NAMING
        return _TOTALSUPPLY10;
    }
    function BALANCEOF6(address ACCOUNT8) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _BALANCES7[ACCOUNT8];
    }
    function TRANSFER0(address RECIPIENT4, uint AMOUNT10) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER10(_MSGSENDER8(), RECIPIENT4, AMOUNT10);
        return true;
    }
    function ALLOWANCE8(address OWNER10, address SPENDER9) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _ALLOWANCES5[OWNER10][SPENDER9];
    }
    function APPROVE6(address SPENDER9, uint AMOUNT10) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE9(_MSGSENDER8(), SPENDER9, AMOUNT10);
        return true;
    }
    function TRANSFERFROM9(address SENDER7, address RECIPIENT4, uint AMOUNT10) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER10(SENDER7, RECIPIENT4, AMOUNT10);
        _APPROVE9(SENDER7, _MSGSENDER8(), _ALLOWANCES5[SENDER7][_MSGSENDER8()].SUB6(AMOUNT10, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function INCREASEALLOWANCE7(address SPENDER9, uint ADDEDVALUE4) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE9(_MSGSENDER8(), SPENDER9, _ALLOWANCES5[_MSGSENDER8()][SPENDER9].ADD8(ADDEDVALUE4));
        return true;
    }
    function DECREASEALLOWANCE8(address SPENDER9, uint SUBTRACTEDVALUE3) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE9(_MSGSENDER8(), SPENDER9, _ALLOWANCES5[_MSGSENDER8()][SPENDER9].SUB6(SUBTRACTEDVALUE3, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _TRANSFER10(address SENDER7, address RECIPIENT4, uint AMOUNT10) internal {	//inject NONSTANDARD NAMING
        require(SENDER7 != address(0), "ERC20: transfer from the zero address");
        require(RECIPIENT4 != address(0), "ERC20: transfer to the zero address");

        _BEFORETOKENTRANSFER5(SENDER7, RECIPIENT4, AMOUNT10);

        _BALANCES7[SENDER7] = _BALANCES7[SENDER7].SUB6(AMOUNT10, "ERC20: transfer amount exceeds balance");
        _BALANCES7[RECIPIENT4] = _BALANCES7[RECIPIENT4].ADD8(AMOUNT10);
        emit TRANSFER10(SENDER7, RECIPIENT4, AMOUNT10);
    }
    function _MINT8(address ACCOUNT8, uint AMOUNT10) internal {	//inject NONSTANDARD NAMING
        require(ACCOUNT8 != address(0), "ERC20: mint to the zero address");

        _BEFORETOKENTRANSFER5(address(0), ACCOUNT8, AMOUNT10);

        _TOTALSUPPLY10 = _TOTALSUPPLY10.ADD8(AMOUNT10);
        _BALANCES7[ACCOUNT8] = _BALANCES7[ACCOUNT8].ADD8(AMOUNT10);
        emit TRANSFER10(address(0), ACCOUNT8, AMOUNT10);
    }
    function _BURN2(address ACCOUNT8, uint AMOUNT10) internal {	//inject NONSTANDARD NAMING
        require(ACCOUNT8 != address(0), "ERC20: burn from the zero address");

        _BEFORETOKENTRANSFER5(ACCOUNT8, address(0), AMOUNT10);

        _BALANCES7[ACCOUNT8] = _BALANCES7[ACCOUNT8].SUB6(AMOUNT10, "ERC20: burn amount exceeds balance");
        _TOTALSUPPLY10 = _TOTALSUPPLY10.SUB6(AMOUNT10);
        emit TRANSFER10(ACCOUNT8, address(0), AMOUNT10);
    }
    function _APPROVE9(address OWNER10, address SPENDER9, uint AMOUNT10) internal {	//inject NONSTANDARD NAMING
        require(OWNER10 != address(0), "ERC20: approve from the zero address");
        require(SPENDER9 != address(0), "ERC20: approve to the zero address");

        _ALLOWANCES5[OWNER10][SPENDER9] = AMOUNT10;
        emit APPROVAL6(OWNER10, SPENDER9, AMOUNT10);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function _BEFORETOKENTRANSFER5(address FROM9, address TO4, uint256 AMOUNT10) internal { }	//inject NONSTANDARD NAMING
}

contract erc20detailed3 is ierc207 {	//inject NONSTANDARD NAMING
    string private _NAME4;	//inject NONSTANDARD NAMING
    string private _SYMBOL3;	//inject NONSTANDARD NAMING
    uint8 private _DECIMALS5;	//inject NONSTANDARD NAMING
    uint256 private _CAP1;	//inject NONSTANDARD NAMING

    constructor (string memory NAME1, string memory SYMBOL10, uint8 DECIMALS2, uint256 CAP9) public {	//inject NONSTANDARD NAMING
        _NAME4 = NAME1;
        _SYMBOL3 = SYMBOL10;
        _DECIMALS5 = DECIMALS2;
        _CAP1 = CAP9;
    }
    function NAME8() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _NAME4;
    }
    function SYMBOL10() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _SYMBOL3;
    }
    function DECIMALS8() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _DECIMALS5;
    }

                                                                        
    function CAP3() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _CAP1;
    }

}

library safemath3 {	//inject NONSTANDARD NAMING
    function ADD8(uint A10, uint B3) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint C10 = A10 + B3;	//inject NONSTANDARD NAMING
        require(C10 >= A10, "SafeMath: addition overflow");

        return C10;
    }
    function SUB6(uint A10, uint B3) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return SUB6(A10, B3, "SafeMath: subtraction overflow");
    }
    function SUB6(uint A10, uint B3, string memory ERRORMESSAGE2) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        require(B3 <= A10, ERRORMESSAGE2);
        uint C10 = A10 - B3;	//inject NONSTANDARD NAMING

        return C10;
    }
    function MUL10(uint A10, uint B3) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        if (A10 == 0) {
            return 0;
        }

        uint C10 = A10 * B3;	//inject NONSTANDARD NAMING
        require(C10 / A10 == B3, "SafeMath: multiplication overflow");

        return C10;
    }
    function DIV1(uint A10, uint B3) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return DIV1(A10, B3, "SafeMath: division by zero");
    }
    function DIV1(uint A10, uint B3, string memory ERRORMESSAGE2) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(B3 > 0, ERRORMESSAGE2);
        uint C10 = A10 / B3;	//inject NONSTANDARD NAMING

        return C10;
    }
}

library address8 {	//inject NONSTANDARD NAMING
    function ISCONTRACT7(address ACCOUNT8) internal view returns (bool) {	//inject NONSTANDARD NAMING
        bytes32 CODEHASH8;	//inject NONSTANDARD NAMING
        bytes32 ACCOUNTHASH10 = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;	//inject NONSTANDARD NAMING
        // solhint-disable-next-line no-inline-assembly
        assembly { CODEHASH8 := extcodehash(ACCOUNT8) }
        return (CODEHASH8 != 0x0 && CODEHASH8 != ACCOUNTHASH10);
    }
}

library safeerc207 {	//inject NONSTANDARD NAMING
    using safemath3 for uint;
    using address8 for address;

    function SAFETRANSFER0(ierc207 TOKEN3, address TO4, uint VALUE10) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN7(TOKEN3, abi.encodeWithSelector(TOKEN3.TRANSFER0.selector, TO4, VALUE10));
    }

    function SAFETRANSFERFROM0(ierc207 TOKEN3, address FROM9, address TO4, uint VALUE10) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN7(TOKEN3, abi.encodeWithSelector(TOKEN3.TRANSFERFROM9.selector, FROM9, TO4, VALUE10));
    }

    function SAFEAPPROVE8(ierc207 TOKEN3, address SPENDER9, uint VALUE10) internal {	//inject NONSTANDARD NAMING
        require((VALUE10 == 0) || (TOKEN3.ALLOWANCE8(address(this), SPENDER9) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN7(TOKEN3, abi.encodeWithSelector(TOKEN3.APPROVE6.selector, SPENDER9, VALUE10));
    }
    function CALLOPTIONALRETURN7(ierc207 TOKEN3, bytes memory DATA10) private {	//inject NONSTANDARD NAMING
        require(address(TOKEN3).ISCONTRACT7(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool SUCCESS10, bytes memory RETURNDATA2) = address(TOKEN3).call(DATA10);	//inject NONSTANDARD NAMING
        require(SUCCESS10, "SafeERC20: low-level call failed");

        if (RETURNDATA2.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(RETURNDATA2, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

                    
contract hdt1 is erc209, erc20detailed3 {	//inject NONSTANDARD NAMING
    using safeerc207 for ierc207;
    using address8 for address;
    using safemath3 for uint;

    address public GOVERNANCE4;	//inject NONSTANDARD NAMING
    address public PENDINGGOV10;	//inject NONSTANDARD NAMING

    mapping (address => bool) public MINTERS7;	//inject NONSTANDARD NAMING

    event NEWPENDINGGOV1(address OLDPENDINGGOV6, address NEWPENDINGGOV5);	//inject NONSTANDARD NAMING

    event NEWGOV0(address OLDGOV6, address NEWGOV3);	//inject NONSTANDARD NAMING

    // Modifiers
    modifier ONLYGOV3() {	//inject NONSTANDARD NAMING
        require(msg.sender == GOVERNANCE4, "HUB-Token: !governance");
        _;
    }

    constructor () public erc20detailed3("HUB.finance", "HDT", 18, 800000000 * 10 ** 18) {
        GOVERNANCE4 = tx.origin;
    }

                                                                                                          
    function MINT5(address _ACCOUNT7, uint256 _AMOUNT8) public {	//inject NONSTANDARD NAMING
        require(MINTERS7[msg.sender], "HUB-Token: !minter");
        _MINT8(_ACCOUNT7, _AMOUNT8);
    }
    
                                                               
    function ADDMINTER2(address _MINTER6) public ONLYGOV3 {	//inject NONSTANDARD NAMING
        MINTERS7[_MINTER6] = true;
    }
    
                                                                  
    function REMOVEMINTER6(address _MINTER6) public ONLYGOV3 {	//inject NONSTANDARD NAMING
        MINTERS7[_MINTER6] = false;
    }

                                                                                       
    function SETPENDINGGOV6(address _PENDINGGOV2)	//inject NONSTANDARD NAMING
        external
        ONLYGOV3
    {
        address OLDPENDINGGOV6 = PENDINGGOV10;	//inject NONSTANDARD NAMING
        PENDINGGOV10 = _PENDINGGOV2;
        emit NEWPENDINGGOV1(OLDPENDINGGOV6, _PENDINGGOV2);
    }

                                                         
    function ACCEPTGOV3()	//inject NONSTANDARD NAMING
        external {
        require(msg.sender == PENDINGGOV10, "HUB-Token: !pending");
        address OLDGOV6 = GOVERNANCE4;	//inject NONSTANDARD NAMING
        GOVERNANCE4 = PENDINGGOV10;
        PENDINGGOV10 = address(0);
        emit NEWGOV0(OLDGOV6, GOVERNANCE4);
    }

                                                                                                                                                                           
    function _BEFORETOKENTRANSFER5(address FROM9, address TO4, uint256 AMOUNT10) internal {	//inject NONSTANDARD NAMING
        super._BEFORETOKENTRANSFER5(FROM9, TO4, AMOUNT10);

        if (FROM9 == address(0)) { // When minting tokens
            require(TOTALSUPPLY3().ADD8(AMOUNT10) <= CAP3(), "HUB-Token: Cap exceeded");
        }
    }
}