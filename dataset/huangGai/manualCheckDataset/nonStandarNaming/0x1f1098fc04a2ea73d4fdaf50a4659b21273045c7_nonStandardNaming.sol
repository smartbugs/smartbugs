pragma solidity 0.5.5;

library safemath31 {	//inject NONSTANDARD NAMING
                                                                                
    function MUL6(uint256 A44, uint256 B24) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (A44 == 0) {
            return 0;
        }

        uint256 C44 = A44 * B24;	//inject NONSTANDARD NAMING
        require(C44 / A44 == B24);

        return C44;
    }

                                                                                                                         
    function DIV36(uint256 A44, uint256 B24) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(B24 > 0);
        uint256 C44 = A44 / B24;	//inject NONSTANDARD NAMING

        return C44;
    }

                                                                                                                            
    function SUB43(uint256 A44, uint256 B24) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(B24 <= A44);
        uint256 C44 = A44 - B24;	//inject NONSTANDARD NAMING

        return C44;
    }

                                                                          
    function ADD61(uint256 A44, uint256 B24) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 C44 = A44 + B24;	//inject NONSTANDARD NAMING
        require(C44 >= A44);

        return C44;
    }

                                                                                                                                                 
    function MOD13(uint256 A44, uint256 B24) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(B24 != 0);
        return A44 % B24;
    }
}

contract ierc2028 {	//inject NONSTANDARD NAMING
    function TRANSFER75(address TO98, uint256 VALUE44) public returns (bool) {}	//inject NONSTANDARD NAMING
}

contract currentking29 {	//inject NONSTANDARD NAMING
  using safemath31 for uint256;

  // initialize
  uint256 public REWARD_PER_WIN25 = 10000000;	//inject NONSTANDARD NAMING
  uint256 public CREATOR_REWARD10 = 100000;	//inject NONSTANDARD NAMING
  address public CREATOR_ADDRESS68;	//inject NONSTANDARD NAMING
  address public GTT_ADDRESS74;	//inject NONSTANDARD NAMING

  // game state params
  uint256 public LASTPAIDBLOCK9;	//inject NONSTANDARD NAMING
  address public CURRENTKING3;	//inject NONSTANDARD NAMING

  constructor() public {
    CREATOR_ADDRESS68 = msg.sender;
    LASTPAIDBLOCK9 = block.number;
    CURRENTKING3 = address(this);
  }

  // can only be called once
  function SETTOKENADDRESS87(address _GTTADDRESS14) public {	//inject NONSTANDARD NAMING
    if (GTT_ADDRESS74 == address(0)) {
      GTT_ADDRESS74 = _GTTADDRESS14;
    }
  }

  function PLAY55() public {	//inject NONSTANDARD NAMING
    uint256 CURRENTBLOCK58 = block.number;	//inject NONSTANDARD NAMING

    // pay old king
    if (CURRENTBLOCK58 != LASTPAIDBLOCK9) {
      PAYOUT26(CURRENTBLOCK58);

      // reinitialize
      LASTPAIDBLOCK9 = CURRENTBLOCK58;
    }

    // set new king
    CURRENTKING3 = msg.sender;
  }

  function PAYOUT26(uint256 _CURRENTBLOCK24) internal {	//inject NONSTANDARD NAMING
    // calculate multiplier (# of unclaimed blocks)
    uint256 NUMBLOCKSTOPAYOUT90 = _CURRENTBLOCK24.SUB43(LASTPAIDBLOCK9);	//inject NONSTANDARD NAMING

    ierc2028(GTT_ADDRESS74).TRANSFER75(CURRENTKING3, REWARD_PER_WIN25.MUL6(NUMBLOCKSTOPAYOUT90));
    ierc2028(GTT_ADDRESS74).TRANSFER75(CREATOR_ADDRESS68, CREATOR_REWARD10.MUL6(NUMBLOCKSTOPAYOUT90));
  }
}