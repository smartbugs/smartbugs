pragma solidity 0.5.4;


library safemath1 {	//inject NONSTANDARD NAMING
  function MUL1(uint256 A0, uint256 B10) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 C8 = A0 * B10;	//inject NONSTANDARD NAMING
    require(A0 == 0 || C8 / A0 == B10);
    return C8;
  }

  function DIV10(uint256 A7, uint256 B2) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(B2 > 0);
    uint256 C2 = A7 / B2;	//inject NONSTANDARD NAMING
    return C2;
  }
  
  function SUB2(uint256 A5, uint256 B6) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(B6 <= A5);
    uint256 C7 = A5 - B6;	//inject NONSTANDARD NAMING
    return C7;
  }

 
  function ADD5(uint256 A1, uint256 B1) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 C9 = A1 + B1;	//inject NONSTANDARD NAMING
    require(C9 >= A1);
    return C9;
  }
}

contract token0 {	//inject NONSTANDARD NAMING
    function BALANCEOF10(address _OWNER9) public view returns (uint256 BALANCE0);	//inject NONSTANDARD NAMING
    function TRANSFER7(address _TO4, uint256 _VALUE5) public returns (bool SUCCESS0);	//inject NONSTANDARD NAMING
}

contract locktokencontract9 {	//inject NONSTANDARD NAMING
    using safemath1 for uint;
 
    uint256[] public FOUNDATIONRELEASESTAGE6 = [	//inject NONSTANDARD NAMING
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        283333333,
        566666666,
        850000000,
        1133333333,
        1416666666,
        1700000000,
        1983333333,
        2266666666,
        2550000000,
        2833333333,
        3116666666,
        3400000000
    ];
    
    uint256[] public TEAMANDADVISERADDREESONESTAGE1 = [	//inject NONSTANDARD NAMING
        0,
        0,
        0,
        0,
        3000000,
        6000000,
        9000000,
        12000000,
        15000000,
        18000000,
        21000000,
        24000000,
        27000000,
        30000000,
        33000000,
        36000000,
        39000000,
        42000000,
        45000000,
        48000000,
        51000000,
        54000000,
        57000000,
        60000000,
        63000000,
        66000000,
        69000000,
        72000000,
        75000000,
        78000000,
        81000000,
        84000000,
        87000000,
        90000000,
        93000000,
        96000000,
        300000000
    ];
    
    uint256[] public TEAMANDADVISERADDREESTWOSTAGE7 = [	//inject NONSTANDARD NAMING
        0,
        0,
        0,
        0,
        7000000,
        14000000,
        21000000,
        28000000,
        35000000,
        42000000,
        49000000,
        56000000,
        63000000,
        70000000,
        77000000,
        84000000,
        91000000,
        98000000,
        105000000,
        112000000,
        119000000,
        126000000,
        133000000,
        140000000,
        147000000,
        154000000,
        161000000,
        168000000,
        175000000,
        182000000,
        189000000,
        196000000,
        203000000,
        210000000,
        217000000,
        224000000,
        1300000000
    ];
    
    
    address public FOUNDATIONADDRESS1 = address(0x98d7cbfF0E5d6807F00A7047FdcdBDb7B1192f57);	//inject NONSTANDARD NAMING
    address public TEAMANDADVISERADDREESONE9 = address(0xb89b941F7cd9eBCBcAc16cA2F03aace5cf8e2edc);	//inject NONSTANDARD NAMING
    address public TEAMANDADVISERADDREESTWO8 = address(0x5a403e651EC2cD3b6B385dC639f1A90ea01017f7);	//inject NONSTANDARD NAMING
    address public GUBITOKENADDRESS0  = address(0x12b2B2331A72d375c453c160B2c8A7010EeA510A);	//inject NONSTANDARD NAMING
    
    
    uint public constant stagesection9  = 300; // 5min	//inject NONSTANDARD NAMING
    uint public STARTTIME7 = now; // 11	//inject NONSTANDARD NAMING
    
    mapping(address => uint256) ADDRESSWITHDRAWALS6;	//inject NONSTANDARD NAMING


    constructor() public {
    }


    function () payable external {
        require(msg.sender == FOUNDATIONADDRESS1 || msg.sender == TEAMANDADVISERADDREESONE9 || msg.sender == TEAMANDADVISERADDREESTWO8 );
        require(msg.value == 0);
        require(now > STARTTIME7);

        token0 TOKEN3 = token0(GUBITOKENADDRESS0);	//inject NONSTANDARD NAMING
        uint BALANCE0 = TOKEN3.BALANCEOF10(address(this));	//inject NONSTANDARD NAMING
        require(BALANCE0 > 0);

        uint256[] memory STAGE0;	//inject NONSTANDARD NAMING
        if (msg.sender == FOUNDATIONADDRESS1) {
            STAGE0 = FOUNDATIONRELEASESTAGE6;
        } else if (msg.sender == TEAMANDADVISERADDREESONE9) {
            STAGE0 = TEAMANDADVISERADDREESONESTAGE1;
        } else if (msg.sender == TEAMANDADVISERADDREESTWO8) {
            STAGE0 = TEAMANDADVISERADDREESTWOSTAGE7;
        }
        uint AMOUNT5 = CALCULATEUNLOCKAMOUNT6(now, BALANCE0, STAGE0);	//inject NONSTANDARD NAMING
        if (AMOUNT5 > 0) {
            ADDRESSWITHDRAWALS6[msg.sender] = ADDRESSWITHDRAWALS6[msg.sender].ADD5(AMOUNT5);

            require(TOKEN3.TRANSFER7(msg.sender, AMOUNT5.MUL1(1e10)));
        }
    }

    function CALCULATEUNLOCKAMOUNT6(uint _NOW5, uint _BALANCE7, uint256[] memory STAGE6) internal view returns (uint AMOUNT5) {	//inject NONSTANDARD NAMING
        uint PHASE3 = _NOW5	//inject NONSTANDARD NAMING
            .SUB2(STARTTIME7)
            .DIV10(stagesection9);
            
        if (PHASE3 >= STAGE6.length) {
            PHASE3 = STAGE6.length - 1;
        }
        
        uint256 UNLOCKABLE10 = STAGE6[PHASE3]	//inject NONSTANDARD NAMING
            .SUB2(ADDRESSWITHDRAWALS6[msg.sender]);

        if (UNLOCKABLE10 == 0) {
            return 0;
        }

        if (UNLOCKABLE10 > _BALANCE7.DIV10(1e10)) {
            return _BALANCE7.DIV10(1e18);
        }
        
        return UNLOCKABLE10;
    }
}