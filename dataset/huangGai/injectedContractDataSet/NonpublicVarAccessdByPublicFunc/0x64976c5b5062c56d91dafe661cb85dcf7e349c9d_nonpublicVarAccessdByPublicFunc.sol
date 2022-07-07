/**
 *Submitted for verification at Etherscan.io on 2020-03-27
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

contract SpellAction {
    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    string  constant public description = "03/27/2020 MakerDAO Executive Spell";

    // The contracts in this list should correspond to MCD core contracts, verify
    //  against the current release list at:
    //     https://changelog.makerdao.com/releases/mainnet/1.0.4/contracts.json
    //
    // Contract addresses pertaining to the SCD ecosystem can be found at:
    //     https://github.com/makerdao/sai#dai-v1-current-deployments
    address constant internal MCD_VAT = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address constant internal MCD_JUG = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
    address constant internal MCD_POT = 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7;


    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 8%):
    //
    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'
    //
    uint256 constant internal SIXTEEN_PCT_RATE = 1000000004706367499604668374;

    uint256 constant internal RAD = 10**45;
    uint256 constant internal MILLION = 10**6;

    function execute() external {

        // Drip Pot and Jugs prior to all modifications.
        PotAbstract(MCD_POT).drip();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        JugAbstract(MCD_JUG).drip("ETH-A");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        JugAbstract(MCD_JUG).drip("BAT-A");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        JugAbstract(MCD_JUG).drip("USDC-A");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC


        // MCD Modifications

        // Set the USDC stability fee
        // USDC_FEE is a value determined by the rate accumulator calculation (see above)
        //  ex. an 8% annual rate will be 1000000002440418608258400030
        //
        // https://vote.makerdao.com/polling-proposal/qmtmgczpt4fnayxqxggwxansej9f8wqs8mqwzwttvr2anx
        //
        // Existing Rate: 20%
        // New Rate: 16%
        uint256 USDC_FEE = SIXTEEN_PCT_RATE;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        JugAbstract(MCD_JUG).file("USDC-A", "duty", USDC_FEE);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC


        // Set the ETH-A debt ceiling
        // ETH_LINE is the number of Dai that can be created with WETH token collateral
        //  ex. a 100 million Dai ETH ceiling will be ETH_LINE = 100000000
        //
        // https://vote.makerdao.com/polling-proposal/qmqbhuhuw6fhhtjw4k5rchcsvkeowhrgw2g1aaqafg96dp
        //
        // Existing Line: 100m
        // New Line: 90m
        uint256 ETH_LINE = 90 * MILLION;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        VatAbstract(MCD_VAT).file("ETH-A", "line", ETH_LINE * RAD);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        // Set the global debt ceiling
        //
        // GLOBAL_AMOUNT is the total number of Dai that can be created by all collateral types
        //  as a whole number
        //  ex. a 100 million Dai global ceiling will be GLOBAL_AMOUNT = 100000000
        //
        // https://vote.makerdao.com/polling-proposal/qmqbhuhuw6fhhtjw4k5rchcsvkeowhrgw2g1aaqafg96dp
        //
        // Existing Ceiling: 133m
        // New Ceiling: 123m
        uint256 GLOBAL_AMOUNT = 123 * MILLION;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        VatAbstract(MCD_VAT).file("Line", GLOBAL_AMOUNT * RAD);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

    }
}

contract DssSpell {

    DSPauseAbstract  internal pause =
        DSPauseAbstract(0xbE286431454714F511008713973d3B053A2d38f3);
    address          internal action;
    bytes32          internal tag;
    uint256          internal eta;
    bytes            internal sig;
    uint256          internal expiration;
    bool             internal done;

    uint256 constant internal MILLION = 10**6;

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
        return SpellAction(action).description();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function schedule() public {
        require(now <= expiration, "This contract has expired");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(eta == 0, "This spell has already been scheduled");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        eta = now + DSPauseAbstract(pause).delay();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        pause.plot(action, tag, sig, eta);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        // NOTE: 'eta' check should mimic the old behavior of 'done', thus
        // preventing these SCD changes from being executed again.
    }

    function cast() public {
        require(!done, "spell-already-cast");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        done = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        pause.exec(action, tag, sig, eta);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}