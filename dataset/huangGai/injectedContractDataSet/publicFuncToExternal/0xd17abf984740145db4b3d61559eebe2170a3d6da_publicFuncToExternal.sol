/**
 *Submitted for verification at Etherscan.io on 2020-08-07
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

interface DSPauseAbstract {
    function delay() external view returns (uint256);
    function plot(address, bytes32, bytes calldata, uint256) external;
    function exec(address, bytes32, bytes calldata, uint256) external returns (bytes memory);
}

interface VatAbstract {
    function file(bytes32, uint256) external;
    function file(bytes32, bytes32, uint256) external;
}

interface CatAbstract {
    function file(bytes32, bytes32, uint256) external;
}

contract SpellAction {

    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/community/76b4a49deca7ff3c8ea32419d779849f092a6c9a/governance/votes/Executive%20vote%20-%20August%207%2C%202020.md -q -O - 2>/dev/null)"
    string constant public description =
        "2020-08-07 MakerDAO Weekly Executive Spell | Hash: 0x8c7bdf48dc5e65db0e06bdffedef066c1eaa91413172c0e4c510285595e79019";

    // MAINNET ADDRESSES
    //
    // The contracts in this list should correspond to MCD core contracts, verify
    // against the current release list at:
    //     https://changelog.makerdao.com/releases/mainnet/1.0.9/contracts.json

    address constant public MCD_VAT = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address constant public MCD_JUG = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
    address constant public MCD_CAT = 0x78F2c2AF65126834c51822F56Be0d7469D7A523E;

    uint256 constant public WAD = 10**18;
    uint256 constant public RAD = 10**45;
    uint256 constant public MILLION = 10**6;

    function execute() public {	//inject PUBLIC FUNC TO EXTERNAL
        // Set the ETH-A lump
        //
        // Existing lump: 500 ETH
        // New lump: 100 ETH
        uint256 ETH_LUMP = 100 * WAD;
        CatAbstract(MCD_CAT).file("ETH-A", "lump", ETH_LUMP);

        // Set the WBTC-A debt ceiling
        //
        // Existing debt: 40 million
        // New debt ceiling: 80 million
        uint256 WBTC_LINE = 80 * MILLION * WAD;
        VatAbstract(MCD_VAT).file("WBTC-A", "line", WBTC_LINE);

        // Set the global debt ceiling
        //
        // Existing Line: 568m
        // New Line: 608m
        VatAbstract(MCD_VAT).file("Line", 608 * MILLION * RAD);
    }
}

contract DssSpell {
    DSPauseAbstract public pause =
        DSPauseAbstract(0xbE286431454714F511008713973d3B053A2d38f3);
    address         public action;
    bytes32         public tag;
    uint256         public eta;
    bytes           public sig;
    uint256         public expiration;
    bool            public done;

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
    }

    function cast() public {
        require(!done, "spell-already-cast");
        done = true;
        pause.exec(action, tag, sig, eta);
    }
}