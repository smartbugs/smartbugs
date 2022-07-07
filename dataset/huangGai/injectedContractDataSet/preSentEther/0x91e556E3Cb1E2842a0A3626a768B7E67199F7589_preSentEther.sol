/**
 *Submitted for verification at Etherscan.io on 2020-04-03
*/

pragma solidity 0.5.12;

// https://github.com/dapphub/ds-pause
contract DSPauseAbstract {
    function delay() public view returns (uint256);
    function plot(address, bytes32, bytes memory, uint256) public;
    function exec(address, bytes32, bytes memory, uint256) public returns (bytes memory);
}

// https://github.com/makerdao/dss/blob/master/src/pot.sol
contract PotAbstract {
    function drip() external returns (uint256);
}

// https://github.com/makerdao/dss/blob/master/src/jug.sol
contract JugAbstract {
    function file(bytes32, bytes32, uint256) external;
    function file(bytes32, uint256) external;
    function file(bytes32, address) external;
    function drip(bytes32) external returns (uint256);
}

// https://github.com/makerdao/dss/blob/master/src/vat.sol
contract VatAbstract {
    function file(bytes32, uint256) external;
    function file(bytes32, bytes32, uint256) external;
}

contract SaiMomLike {
    function setCap(uint256) external;
    function setFee(uint256) external;
}

contract SpellAction {
    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    string  constant public description = "04/03/2020 MakerDAO Executive Spell";

    // The contracts in this list should correspond to MCD core contracts, verify
    //  against the current release list at:
    //     https://changelog.makerdao.com/releases/mainnet/1.0.4/contracts.json
    //
    // Contract addresses pertaining to the SCD ecosystem can be found at:
    //     https://github.com/makerdao/sai#dai-v1-current-deployments
    address constant public MCD_VAT = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address constant public MCD_JUG = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
    address constant public MCD_POT = 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7;

    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 8%):
    //
    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'
    //
    uint256 constant public TWELVE_PCT_RATE = 1000000003593629043335673582;

    uint256 constant public RAD = 10**45;
    uint256 constant public MILLION = 10**6;

    function execute() external {

        // Drip Pot and Jugs prior to all modifications.
        PotAbstract(MCD_POT).drip();
        JugAbstract(MCD_JUG).drip("ETH-A");
        JugAbstract(MCD_JUG).drip("BAT-A");
        JugAbstract(MCD_JUG).drip("USDC-A");

        // MCD Modifications

        // Set the USDC stability fee
        // USDC_FEE is a value determined by the rate accumulator calculation (see above)
        //  ex. an 8% annual rate will be 1000000002440418608258400030
        //
        // https://vote.makerdao.com/polling-proposal/qmc2ebl5rbvdq3vcgypyhjshwqakxw9rwwowrvzulpnmho
        //
        // Existing Rate: 16%
        // New Rate: 12%
        uint256 USDC_FEE = TWELVE_PCT_RATE;
        JugAbstract(MCD_JUG).file("USDC-A", "duty", USDC_FEE);

        // Set the Sai debt ceiling for the migration contract
        // SAI_LINE is the number of Dai that can be created with Sai token collateral
        //  ex. a 10 million Dai ETH ceiling will be SAI_LINE = 10000000
        //
        // https://vote.makerdao.com/polling-proposal/qmz4ttjnhbwsmwmlip73hpxsl7uuybk371cgb4kyxyujst
        //
        // Existing Line: 10m
        // New Line: 0
        uint256 SAI_LINE = 0;
        VatAbstract(MCD_VAT).file("SAI", "line", SAI_LINE);

        // Set the global debt ceiling
        //
        // GLOBAL_AMOUNT is the total number of Dai that can be created by all collateral types
        //  as a whole number
        //  ex. a 100 million Dai global ceiling will be GLOBAL_AMOUNT = 100000000
        //
        // subtract 10m from global ceiling due to reduction of SAI DC
        //
        // Existing Ceiling: 123m
        // New Ceiling: 113m
        uint256 GLOBAL_AMOUNT = 113 * MILLION;
        VatAbstract(MCD_VAT).file("Line", GLOBAL_AMOUNT * RAD);
    }
}

contract DssSpell {

    DSPauseAbstract  public pause =
        DSPauseAbstract(0xbE286431454714F511008713973d3B053A2d38f3);
    address          public action;
    bytes32          public tag;
    uint256          public eta;
    bytes            public sig;
    uint256          public expiration;
    bool             public done;

    uint256 constant internal MILLION = 10**6;

    address constant public SAIMOM = 0xF2C5369cFFb8Ea6284452b0326e326DbFdCb867C;
    uint256 constant SCD_EIGHT_PCT_FEE = 1000000002440418608258400030;

    constructor() public {
        sig = abi.encodeWithSignature("execute()");
        action = address(new SpellAction());
        bytes32 _tag;
        address _action = action;
        assembly { _tag := extcodehash(_action) }
        tag = _tag;
        expiration = now + 30 days;
    }

    function description() public view returns (string memory) {
        return SpellAction(action).description();
    }

    function schedule() public {
        require(now <= expiration, "This contract has expired");
        require(address(this).balance == 0, "This spell has already been scheduled");	//inject PRESENT ETHER
        eta = now + DSPauseAbstract(pause).delay();
        pause.plot(action, tag, sig, eta);

        // NOTE: 'eta' check should mimic the old behavior of 'done', thus
        // preventing these SCD changes from being executed again.

        // Raise Stability Fee in SCD from to 8% (from 7.5%)
        //
        // https://vote.makerdao.com/polling-proposal/qmuenso3mq7ndchi5qdgyjzt3zwstibabbga64g3npihrh
        // 
        // Existing Rate: 7.5%
        // New Rate: 8%
        SaiMomLike(SAIMOM).setFee(SCD_EIGHT_PCT_FEE);
    }

    function cast() public {
        require(!done, "spell-already-cast");
        done = true;
        pause.exec(action, tag, sig, eta);
    }
}