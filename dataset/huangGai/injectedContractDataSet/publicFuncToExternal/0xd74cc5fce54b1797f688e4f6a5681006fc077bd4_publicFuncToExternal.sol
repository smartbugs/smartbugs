/**
 *Submitted for verification at Etherscan.io on 2020-03-26
*/

pragma solidity ^0.5.12;

// https://github.com/dapphub/ds-pause
contract DSPauseAbstract {
    function delay() public view returns (uint256);
    function plot(address, bytes32, bytes memory, uint256) public;
    function exec(address, bytes32, bytes memory, uint256) public returns (bytes memory);
}

// https://github.com/makerdao/dss/blob/master/src/flop.sol
contract FlopAbstract {
    function kicks() public view returns (uint256);
}

// https://github.com/makerdao/dss/blob/master/src/vat.sol
contract VatAbstract {
    function dai(address) public view returns (uint256);
    function sin(address) public view returns (uint256);
    function suck(address, address, uint256) external;
}

// https://github.com/makerdao/dss/blob/master/src/vow.sol
contract VowAbstract {
    function sin(uint256) public view returns (uint256);
    function Sin() public view returns (uint256);
    function Ash() public view returns (uint256);
    function sump() public view returns (uint256);
    function kiss(uint256) external;
    function flop() external returns (uint256);
}


contract SpellAction {
    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    string  constant public description = "March 2020 MakerDAO Flop Unblock Spell";

    // The contracts in this list should correspond to MCD core contracts, verify
    //  against the current release list at:
    //     https://changelog.makerdao.com/releases/mainnet/1.0.4/contracts.json
    //
    // Contract addresses pertaining to the SCD ecosystem can be found at:
    //     https://github.com/makerdao/sai#dai-v1-current-deployments
    address constant public MCD_VAT  = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address constant public MCD_VOW  = 0xA950524441892A31ebddF91d3cEEFa04Bf454466;
    address constant public MCD_FLOP = 0x4D95A049d5B0b7d32058cd3F2163015747522e99;

    uint256 constant public WAD = 10**18;
    uint256 constant public RAD = 10**45;
    uint256 constant public MILLION = 10**6;
    uint256 constant public HOUR = 3600; // in seconds
    uint256 constant public DAY = 24 * HOUR; // in seconds

    uint256 constant public T2020_03_27_1200EDT = 1585324800;

    function execute() public {	//inject PUBLIC FUNC TO EXTERNAL
        // Must start after noon EDT on 2020/03/27
        require(now >= T2020_03_27_1200EDT, "too-soon");

        uint256 diff = now - T2020_03_27_1200EDT;

        // Must start within a two hour window of the daily start time
        require(diff % DAY <= 2*HOUR, "not within two hours of noon EDT");

        // Must start on a weekday
        require((diff / DAY) != 1 && (diff / DAY) != 2, "not a weekday");

        // This check ensures there are no unbid flops active
        require(FlopAbstract(MCD_FLOP).kicks() == 86, "possibility-of-unbid-flops");

        // reconcile as much Ash as possible, then unstick
        uint256 joy = VatAbstract(MCD_VAT).dai(MCD_VOW);
        uint256 Ash = VowAbstract(MCD_VOW).Ash();
        require(joy < Ash);
        VowAbstract(MCD_VOW).kiss(joy);
        Ash = Ash - joy;  // safe because kiss did not revert

        // The remaining Ash is stuck; convert it to woe.
        VatAbstract(MCD_VAT).suck(MCD_VOW, MCD_VOW, Ash);
        VowAbstract(MCD_VOW).kiss(Ash);

        // Ash is zero now, so woe is just Awe - Sin
        uint256 woe  = VatAbstract(MCD_VAT).sin(MCD_VOW) - VowAbstract(MCD_VOW).Sin();
        uint256 sump = VowAbstract(MCD_VOW).sump();
        while (woe >= sump) {
            VowAbstract(MCD_VOW).flop();
            woe -= sump;
        }
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
    uint256 constant internal WAD = 10**18;

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
        require(eta == 0, "This spell has already been scheduled");
        eta = now + DSPauseAbstract(pause).delay();
        pause.plot(action, tag, sig, eta);

        // NOTE: 'eta' check should mimic the old behavior of 'done', thus
        // preventing these SCD changes from being executed again.
    }

    function cast() public {
        require(!done, "spell-already-cast");
        done = true;
        pause.exec(action, tag, sig, eta);
    }
}