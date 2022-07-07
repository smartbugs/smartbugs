/**
 *Submitted for verification at Etherscan.io on 2020-07-17
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
    function setOwner(address) public;
    function setAuthority(address) public;
    function setDelay(uint256) public;
    function plans(bytes32) public view returns (bool);
    function proxy() public view returns (address);
    function delay() public view returns (uint256);
    function plot(address, bytes32, bytes memory, uint256) public;
    function drop(address, bytes32, bytes memory, uint256) public;
    function exec(address, bytes32, bytes memory, uint256) public returns (bytes memory);
}

// https://github.com/makerdao/dss/blob/master/src/vat.sol
contract VatAbstract {
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function can(address, address) public view returns (uint256);
    function hope(address) external;
    function nope(address) external;
    function ilks(bytes32) external view returns (uint256, uint256, uint256, uint256, uint256);
    function urns(bytes32, address) public view returns (uint256, uint256);
    function gem(bytes32, address) public view returns (uint256);
    function dai(address) public view returns (uint256);
    function sin(address) public view returns (uint256);
    function debt() public view returns (uint256);
    function vice() public view returns (uint256);
    function Line() public view returns (uint256);
    function live() public view returns (uint256);
    function init(bytes32) external;
    function file(bytes32, uint256) external;
    function file(bytes32, bytes32, uint256) external;
    function cage() external;
    function slip(bytes32, address, int256) external;
    function flux(bytes32, address, address, uint256) external;
    function move(address, address, uint256) external;
    function frob(bytes32, address, address, address, int256, int256) external;
    function fork(bytes32, address, address, int256, int256) external;
    function grab(bytes32, address, address, address, int256, int256) external;
    function heal(uint256) external;
    function suck(address, address, uint256) external;
    function fold(bytes32, address, int256) external;
}

// https://github.com/makerdao/dss/blob/master/src/jug.sol
contract JugAbstract {
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function ilks(bytes32) public view returns (uint256, uint256);
    function vat() public view returns (address);
    function vow() public view returns (address);
    function base() public view returns (address);
    function init(bytes32) external;
    function file(bytes32, bytes32, uint256) external;
    function file(bytes32, uint256) external;
    function file(bytes32, address) external;
    function drip(bytes32) external returns (uint256);
}

// https://github.com/makerdao/dss/blob/master/src/pot.sol
contract PotAbstract {
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function pie(address) public view returns (uint256);
    function Pie() public view returns (uint256);
    function dsr() public view returns (uint256);
    function chi() public view returns (uint256);
    function vat() public view returns (address);
    function vow() public view returns (address);
    function rho() public view returns (uint256);
    function live() public view returns (uint256);
    function file(bytes32, uint256) external;
    function file(bytes32, address) external;
    function cage() external;
    function drip() external returns (uint256);
    function join(uint256) external;
    function exit(uint256) external;
}

contract SpellAction {
    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    string constant public description = "2020-07-10   MakerDAO Executive Spell";

    // The contracts in this list should correspond to MCD core contracts, verify
    //  against the current release list at:
    //     https://changelog.makerdao.com/releases/mainnet/1.0.8/contracts.json
    address constant MCD_VAT = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address constant MCD_JUG = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
    address constant MCD_POT = 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7;

    uint256 constant THOUSAND = 10**3;
    uint256 constant MILLION  = 10**6;
    uint256 constant WAD      = 10**18;
    uint256 constant RAY      = 10**27;
    uint256 constant RAD      = 10**45;

    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 8%):
    //
    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'

    function execute() external {
        // Perform drips
        PotAbstract(MCD_POT).drip();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        JugAbstract(MCD_JUG).drip("ETH-A");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        JugAbstract(MCD_JUG).drip("BAT-A");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        JugAbstract(MCD_JUG).drip("USDC-A");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        JugAbstract(MCD_JUG).drip("USDC-B");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        JugAbstract(MCD_JUG).drip("TUSD-A");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        JugAbstract(MCD_JUG).drip("WBTC-A");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        JugAbstract(MCD_JUG).drip("KNC-A");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        JugAbstract(MCD_JUG).drip("ZRX-A");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        // Set the global debt ceiling
        // Existing Line: 245m
        // New Line: 265m
        VatAbstract(MCD_VAT).file("Line", 265 * MILLION * RAD);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        // Set the ETH-A debt ceiling
        // Existing Line: 160m
        // New Line: 180m
        VatAbstract(MCD_VAT).file("ETH-A", "line", 180 * MILLION * RAD);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
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
    }

    function cast() public {
        require(!done, "spell-already-cast");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        done = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        pause.exec(action, tag, sig, eta);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}