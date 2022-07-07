/**
 *Submitted for verification at Etherscan.io on 2020-07-24
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

// https://github.com/makerdao/dss/blob/master/src/spot.sol
contract SpotAbstract {
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function ilks(bytes32) public view returns (address, uint256);
    function vat() public view returns (address);
    function par() public view returns (uint256);
    function live() public view returns (uint256);
    function file(bytes32, bytes32, address) external;
    function file(bytes32, uint256) external;
    function file(bytes32, bytes32, uint256) external;
    function poke(bytes32) external;
    function cage() external;
}

// https://github.com/makerdao/median
contract MedianAbstract {
    function wards(address) external view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    function age() external view returns (uint32);
    function wat() external view returns (bytes32);
    function bar() external view returns (uint256);
    function orcl(address) external view returns (uint256);
    function bud(address) external view returns (uint256);
    function slot(uint8) external view returns (address);
    function read() external view returns (uint256);
    function peek() external view returns (uint256, bool);
    function lift(address[] calldata) external;
    function drop(address[] calldata) external;
    function setBar(uint256) external;
    function kiss(address) external;
    function diss(address) external;
    function kiss(address[] calldata) external;
    function diss(address[] calldata) external;
    function poke(uint256[] calldata, uint256[] calldata, uint8[] calldata, bytes32[] calldata, bytes32[] calldata) external;
}

contract SpellAction {
    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    string constant public description = "2020-07-24   MakerDAO Executive Spell";

    // The contracts in this list should correspond to MCD core contracts, verify
    //  against the current release list at:
    //     https://changelog.makerdao.com/releases/mainnet/1.0.8/contracts.json
    address constant MCD_JUG = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
    address constant MCD_POT = 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7;
    address constant MCD_SPOT = 0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3;

    address constant GITCOIN_OLD = 0xA4188B523EccECFbAC49855eB52eA0b55c4d56dd;
    address constant GITCOIN     = 0x77EB6CF8d732fe4D92c427fCdd83142DB3B742f7;

    address constant BATUSD = 0x18B4633D6E39870f398597f3c1bA8c4A41294966;
    address constant BTCUSD = 0xe0F30cb149fAADC7247E953746Be9BbBB6B5751f;
    address constant ETHBTC = 0x81A679f98b63B3dDf2F17CB5619f4d6775b3c5ED;
    address constant ETHUSD = 0x64DE91F5A373Cd4c28de3600cB34C7C6cE410C85;
    address constant KNCUSD = 0x83076a2F42dc1925537165045c9FDe9A4B71AD97;
    address constant ZRXUSD = 0x956ecD6a9A9A0d84e8eB4e6BaaC09329E202E55e;

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
        PotAbstract(MCD_POT).drip();

        JugAbstract(MCD_JUG).drip("ETH-A");
        JugAbstract(MCD_JUG).drip("BAT-A");
        JugAbstract(MCD_JUG).drip("USDC-A");
        JugAbstract(MCD_JUG).drip("USDC-B");
        JugAbstract(MCD_JUG).drip("TUSD-A");
        JugAbstract(MCD_JUG).drip("WBTC-A");
        JugAbstract(MCD_JUG).drip("KNC-A");
        JugAbstract(MCD_JUG).drip("ZRX-A");

        address[] memory gitcoin_old = new address[](1);
        gitcoin_old[0] = GITCOIN_OLD;

        address[] memory gitcoin = new address[](1);
        gitcoin[0] = GITCOIN;

        // Drop Old Gitcoin
        MedianAbstract(BATUSD).drop(gitcoin_old);
        MedianAbstract(BTCUSD).drop(gitcoin_old);
        MedianAbstract(ETHBTC).drop(gitcoin_old);
        MedianAbstract(ETHUSD).drop(gitcoin_old);
        MedianAbstract(KNCUSD).drop(gitcoin_old);
        MedianAbstract(ZRXUSD).drop(gitcoin_old);

        // Lift New Gitcoin
        MedianAbstract(BATUSD).lift(gitcoin);
        MedianAbstract(BTCUSD).lift(gitcoin);
        MedianAbstract(ETHBTC).lift(gitcoin);
        MedianAbstract(ETHUSD).lift(gitcoin);
        MedianAbstract(KNCUSD).lift(gitcoin);
        MedianAbstract(ZRXUSD).lift(gitcoin);

        // Set the USDC-A Liquidation Ratio
        // Existing mat: 120%
        // New mat: 110%
        SpotAbstract(MCD_SPOT).file("USDC-A", "mat", 110 * RAY / 100);

        // Update USDC-A spot value in Vat
        SpotAbstract(MCD_SPOT).poke("USDC-A");
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
    }

    function cast() public {
        require(!done, "spell-already-cast");
        done = true;
        pause.exec(action, tag, sig, eta);
    }
}