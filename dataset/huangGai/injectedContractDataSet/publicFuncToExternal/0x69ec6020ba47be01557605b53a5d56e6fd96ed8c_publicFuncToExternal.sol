/**
 *Submitted for verification at Etherscan.io on 2020-08-02
*/

// Copyright (C) 2020 Maker Ecosystem Growth Holdings, INC.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity 0.5.12;

// https://github.com/dapphub/ds-pause
contract DSPauseAbstract {
    function delay() public view returns (uint256);
    function plot(address, bytes32, bytes memory, uint256) public;
    function exec(address, bytes32, bytes memory, uint256) public returns (bytes memory);
}

// https://github.com/makerdao/dss/blob/master/src/pot.sol
contract PotAbstract {
    function file(bytes32, uint256) external;
    function drip() external returns (uint256);
}

// https://github.com/makerdao/dss/blob/master/src/jug.sol
contract JugAbstract {
    function file(bytes32, bytes32, uint256) external;
    function drip(bytes32) external returns (uint256);
}

// https://github.com/makerdao/dss/blob/master/src/vat.sol
contract VatAbstract {
    function ilks(bytes32) external view returns (uint256, uint256, uint256, uint256, uint256);
    function file(bytes32, uint256) external;
    function file(bytes32, bytes32, uint256) external;
}

// https://github.com/makerdao/dss/blob/master/src/flip.sol
contract FlipAbstract {
    function file(bytes32, uint256) external;
}

// https://github.com/makerdao/flipper-mom/blob/master/src/FlipperMom.sol
contract FlipperMomAbstract {
    function rely(address) external;
    function deny(address) external;
}

// https://github.com/makerdao/ilk-registry/blob/master/src/IlkRegistry.sol
contract IlkRegistryAbstract {
    function list() external view returns (bytes32[] memory);
    function flip(bytes32) external view returns (address);
}

contract SpellAction {
    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    string constant public description = "DEFCON-5 Emergency Spell";

    // The contracts in this list should correspond to MCD core contracts, verify
    //  against the current release list at:
    //     https://changelog.makerdao.com/releases/mainnet/1.0.9/contracts.json
    //
    address constant MCD_VAT      = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address constant MCD_JUG      = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
    address constant MCD_POT      = 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7;
    address constant ILK_REGISTRY = 0xbE4F921cdFEf2cF5080F9Cf00CC2c14F1F96Bd07;
    address constant FLIPPER_MOM  = 0x9BdDB99625A711bf9bda237044924E34E8570f75;

    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 8%):
    //
    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'
    //
    uint256 constant ZERO_PCT_RATE = 1000000000000000000000000000;

    // Common orders of magnitude needed in spells
    //
    uint256 constant WAD = 10**18;
    uint256 constant RAY = 10**27;
    uint256 constant RAD = 10**45;
    uint256 constant MLN = 10**6;
    uint256 constant BLN = 10**9;

    function execute() public {	//inject PUBLIC FUNC TO EXTERNAL
        // MCD Modifications

        // Ensure we drip pot prior to modifications (housekeeping).
        //
        PotAbstract(MCD_POT).drip();

        // Loop over all ilks
        //
        IlkRegistryAbstract registry = IlkRegistryAbstract(ILK_REGISTRY);
        bytes32[] memory ilks = registry.list();

        for (uint i = 0; i < ilks.length; i++) {
            // Always drip the ilk prior to modifications (housekeeping)
            //
            JugAbstract(MCD_JUG).drip(ilks[i]);

            // skip the rest of the loop for the following ilks:
            //
            if (ilks[i] == "USDC-A" ||
                ilks[i] == "USDC-B" ||
                ilks[i] == "TUSD-A"
            ) { continue; }

            // Enable collateral liquidations
            //
            // This change will enable liquidations for collateral types
            // and is colloquially referred to as the "circuit breaker".
            //
            FlipperMomAbstract(FLIPPER_MOM).rely(registry.flip(ilks[i]));
        }
    }
}

contract DssSpell {

    DSPauseAbstract  public pause;
    address          public action;
    bytes32          public tag;
    uint256          public eta;
    bytes            public sig;
    uint256          public expiration;
    bool             public done;

    address constant MCD_PAUSE    = 0xbE286431454714F511008713973d3B053A2d38f3;
    address constant ILK_REGISTRY = 0xbE4F921cdFEf2cF5080F9Cf00CC2c14F1F96Bd07;

    uint256 constant T2020_10_01_1200UTC = 1601553600;

    constructor() public {
        sig = abi.encodeWithSignature("execute()");
        action = address(new SpellAction());
        bytes32 _tag;
        address _action = action;
        assembly { _tag := extcodehash(_action) }
        tag = _tag;
        pause = DSPauseAbstract(MCD_PAUSE);
        expiration = T2020_10_01_1200UTC;
    }

    function description() public view returns (string memory) {
        return SpellAction(action).description();
    }

    function schedule() public {
        require(now <= expiration, "This contract has expired");
        require(eta == 0, "This spell has already been scheduled");
        eta = now + pause.delay();
        pause.plot(action, tag, sig, eta);
    }

    function cast() public {
        require(!done, "spell-already-cast");
        done = true;
        pause.exec(action, tag, sig, eta);
    }
}