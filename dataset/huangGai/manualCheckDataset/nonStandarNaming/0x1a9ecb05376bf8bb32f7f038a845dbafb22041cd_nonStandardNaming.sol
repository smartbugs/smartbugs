pragma solidity ^0.5.7;

library safemath63 {	//inject NONSTANDARD NAMING
    function MUL45(uint256 A51, uint256 B68) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (A51 == 0) {
            return 0;
        }

        uint256 C15 = A51 * B68;	//inject NONSTANDARD NAMING
        require(C15 / A51 == B68);

        return C15;
    }

    function DIV63(uint256 A51, uint256 B68) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(B68 > 0);
        uint256 C15 = A51 / B68;	//inject NONSTANDARD NAMING

        return C15;
    }

    function SUB29(uint256 A51, uint256 B68) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(B68 <= A51);
        uint256 C15 = A51 - B68;	//inject NONSTANDARD NAMING

        return C15;
    }

    function ADD33(uint256 A51, uint256 B68) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 C15 = A51 + B68;	//inject NONSTANDARD NAMING
        require(C15 >= A51);

        return C15;
    }
}

contract mono88 {	//inject NONSTANDARD NAMING
    using safemath63 for uint256;

    mapping (address => uint256) private BALANCES70;	//inject NONSTANDARD NAMING
    mapping (address => mapping (address => uint256)) private ALLOWED10;	//inject NONSTANDARD NAMING
    uint256 private _TOTALSUPPLY7 = 8235000;	//inject NONSTANDARD NAMING

    string public constant name25 = "Mono";	//inject NONSTANDARD NAMING
    string public constant symbol49 = "MMONO";	//inject NONSTANDARD NAMING
    uint8 public constant decimals44 = 6;	//inject NONSTANDARD NAMING

    function TOTALSUPPLY58() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _TOTALSUPPLY7;
    }

    function BALANCEOF4(address OWNER89) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return BALANCES70[OWNER89];
    }

    function ALLOWANCE61(address OWNER89, address SPENDER90) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return ALLOWED10[OWNER89][SPENDER90];
    }

    event TRANSFER77(address indexed FROM79, address indexed TO89, uint256 VALUE84);	//inject NONSTANDARD NAMING
    function _TRANSFER16(address FROM79, address TO89, uint256 VALUE84) internal {	//inject NONSTANDARD NAMING
        require(TO89 != address(0));

        BALANCES70[FROM79] = BALANCES70[FROM79].SUB29(VALUE84);
        BALANCES70[TO89] = BALANCES70[TO89].ADD33(VALUE84);
        emit TRANSFER77(FROM79, TO89, VALUE84);
    }

    function TRANSFER61(address TO89, uint256 VALUE84) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER16(msg.sender, TO89, VALUE84);
        return true;
    }

    event APPROVAL84(address indexed OWNER89, address indexed SPENDER90, uint256 VALUE84);	//inject NONSTANDARD NAMING
    function APPROVE84(address SPENDER90, uint256 VALUE84) public returns (bool) {	//inject NONSTANDARD NAMING
        require(SPENDER90 != address(0));

        ALLOWED10[msg.sender][SPENDER90] = VALUE84;
        emit APPROVAL84(msg.sender, SPENDER90, VALUE84);
        return true;
    }

    function TRANSFERFROM88(address FROM79, address TO89, uint256 VALUE84) public returns (bool) {	//inject NONSTANDARD NAMING
        ALLOWED10[FROM79][msg.sender] = ALLOWED10[FROM79][msg.sender].SUB29(VALUE84);
        _TRANSFER16(FROM79, TO89, VALUE84);
        emit APPROVAL84(FROM79, msg.sender, ALLOWED10[FROM79][msg.sender]);
        return true;
    }

    constructor() public {
        BALANCES70[0x4b09b4aeA5f9C616ebB6Ee0097B62998Cb332275] = 8235000000000;
        emit TRANSFER77(address(0x0), 0x4b09b4aeA5f9C616ebB6Ee0097B62998Cb332275, 8235000000000);
    }
}