                                                                 

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface crtokeninterface8 {	//inject NONSTANDARD NAMING
    function UNDERLYING10() external view returns (address);	//inject NONSTANDARD NAMING
}

interface connectorsinterface7 {	//inject NONSTANDARD NAMING
    function CHIEF0(address) external view returns (bool);	//inject NONSTANDARD NAMING
}

interface indexinterface4 {	//inject NONSTANDARD NAMING
    function MASTER4() external view returns (address);	//inject NONSTANDARD NAMING
}

contract helpers0 {	//inject NONSTANDARD NAMING
    address public constant connectors9 = 0xD6A602C01a023B98Ecfb29Df02FBA380d3B21E0c;	//inject NONSTANDARD NAMING
    address public constant instaindex2 = 0x2971AdFa57b20E5a416aE5a708A8655A9c74f723;	//inject NONSTANDARD NAMING
    uint public VERSION10 = 1;	//inject NONSTANDARD NAMING

    mapping (address => address) public CRTOKENMAPPING10;	//inject NONSTANDARD NAMING

    event LOGADDCRTOKENMAPPING8(address CRTOKEN4);	//inject NONSTANDARD NAMING
    
    modifier ISCHIEF10 {	//inject NONSTANDARD NAMING
        require(
            connectorsinterface7(connectors9).CHIEF0(msg.sender) ||
            indexinterface4(instaindex2).MASTER4() == msg.sender, "not-Chief");
        _;
    }

    function _ADDCRTKNMAPPING10(address CRTKN0) internal {	//inject NONSTANDARD NAMING
        address CERC2010 = CRTKN0;	//inject NONSTANDARD NAMING
        address ERC2010 = crtokeninterface8(CERC2010).UNDERLYING10();	//inject NONSTANDARD NAMING
        require(CRTOKENMAPPING10[ERC2010] == address(0), "Token-Already-Added");
        CRTOKENMAPPING10[ERC2010] = CERC2010;
        emit LOGADDCRTOKENMAPPING8(CRTKN0);
    }

    function ADDCRTKNMAPPING0(address[] memory CRTKNS6) public ISCHIEF10 {	//inject NONSTANDARD NAMING
        require(CRTKNS6.length > 0, "No-CrToken-length");
        for (uint I10 = 0; I10 < CRTKNS6.length; I10++) {	//inject NONSTANDARD NAMING
            _ADDCRTKNMAPPING10(CRTKNS6[I10]);
        }
    }
}


contract instacreammapping3 is helpers0 {	//inject NONSTANDARD NAMING
    constructor(address[] memory CRTKNS7) public {	//inject NONSTANDARD NAMING
        address ETHADDRESS0 = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;	//inject NONSTANDARD NAMING
        address CRETH6 = 0xD06527D5e56A3495252A528C4987003b712860eE;	//inject NONSTANDARD NAMING
        CRTOKENMAPPING10[ETHADDRESS0] = CRETH6;
        for (uint I8 = 0; I8 < CRTKNS7.length; I8++) {	//inject NONSTANDARD NAMING
            _ADDCRTKNMAPPING10(CRTKNS7[I8]);
        }
    }

    string constant public name6 = "Cream-finance-v1.0";	//inject NONSTANDARD NAMING
}