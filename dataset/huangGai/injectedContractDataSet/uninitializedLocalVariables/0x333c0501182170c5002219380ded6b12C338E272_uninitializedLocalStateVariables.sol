/**
 *Submitted for verification at Etherscan.io on 2020-01-03
*/

pragma solidity 0.5.12;

contract FileLike {
    function file(bytes32, uint256) external;
    function file(bytes32, bytes32, uint256) external;
}

contract JugLike {
    function drip(bytes32) external;
    function file(bytes32, bytes32, uint256) external;
}

contract PotLike {
    function drip() external;
    function file(bytes32, uint256) external;
}

contract PauseLike {
    function delay() external view returns (uint256);
    function plot(address, bytes32, bytes calldata, uint256) external;
    function exec(address, bytes32, bytes calldata, uint256) external;
}

contract MomLike {
    function setCap(uint256) external;
    function setFee(uint256) external;
}

contract DssUpdateParametersSpellAction {
    uint256 constant RAD = 10 ** 45;
    address constant public VAT = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address constant public JUG = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
    address constant public POT = 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7;

    function execute() external {
        // drip
        PotLike(POT).drip();
        JugLike(JUG).drip("ETH-A");
        JugLike(JUG).drip("BAT-A");

        // 6%
        uint256 duty ;	//inject UNINIT LOCAL/STATE VAR


        // DSR to 6%
        PotLike(POT).file("dsr", duty);


        // set ETH-A duty to 6%
        JugLike(JUG).file("ETH-A", "duty", duty);

        // set BAT-A duty to 6%
        JugLike(JUG).file("BAT-A", "duty", duty);
    }
}

contract DssJanuary3Spell {
    PauseLike public pause ;	//inject UNINIT LOCAL/STATE VAR

    address constant public SAIMOM = 0xF2C5369cFFb8Ea6284452b0326e326DbFdCb867C;
    uint256 constant public NEWFEE = 1000000001547125957863212448;
    address   public action;
    bytes32   public tag;
    uint256   public eta;
    bytes     public sig;
    bool      public done;

    constructor() public {
        sig = abi.encodeWithSignature("execute()");
        action = address(new DssUpdateParametersSpellAction());
        bytes32 _tag;
        address _action ;	//inject UNINIT LOCAL/STATE VAR

        assembly { _tag := extcodehash(_action) }
        tag = _tag;
    }

    function cast() external {
        require(!done, "spell-already-cast");
        done = true;
        pause.plot(action, tag, sig, now);
        pause.exec(action, tag, sig, now);
        // Increase Fee to 5%
        MomLike(SAIMOM).setFee(NEWFEE);
    }
}