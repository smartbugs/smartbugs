                                                                 

// hevm: flattened sources of src/DssSpell.sol
pragma solidity =0.5.12 >0.4.13 >=0.4.23 >=0.5.12;

                                                      
                               

// https://github.com/dapphub/ds-pause
interface DSPauseAbstract {
    function SETOWNER590(address) external;	//inject NONSTANDARD NAMING
    function SETAUTHORITY631(address) external;	//inject NONSTANDARD NAMING
    function SETDELAY362(uint256) external;	//inject NONSTANDARD NAMING
    function PLANS667(bytes32) external view returns (bool);	//inject NONSTANDARD NAMING
    function PROXY384() external view returns (address);	//inject NONSTANDARD NAMING
    function DELAY460() external view returns (uint256);	//inject NONSTANDARD NAMING
    function PLOT131(address, bytes32, bytes calldata, uint256) external;	//inject NONSTANDARD NAMING
    function DROP945(address, bytes32, bytes calldata, uint256) external;	//inject NONSTANDARD NAMING
    function EXEC84(address, bytes32, bytes calldata, uint256) external returns (bytes memory);	//inject NONSTANDARD NAMING
}

                                                 
                               

// https://github.com/makerdao/dss/blob/master/src/jug.sol
interface JugAbstract {
    function WARDS9(address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function RELY664(address) external;	//inject NONSTANDARD NAMING
    function DENY283(address) external;	//inject NONSTANDARD NAMING
    function ILKS778(bytes32) external view returns (uint256, uint256);	//inject NONSTANDARD NAMING
    function VAT142() external view returns (address);	//inject NONSTANDARD NAMING
    function VOW391() external view returns (address);	//inject NONSTANDARD NAMING
    function BASE726() external view returns (address);	//inject NONSTANDARD NAMING
    function INIT893(bytes32) external;	//inject NONSTANDARD NAMING
    function FILE40(bytes32, bytes32, uint256) external;	//inject NONSTANDARD NAMING
    function FILE40(bytes32, uint256) external;	//inject NONSTANDARD NAMING
    function FILE40(bytes32, address) external;	//inject NONSTANDARD NAMING
    function DRIP219(bytes32) external returns (uint256);	//inject NONSTANDARD NAMING
}

                                                    
                               

// https://github.com/makerdao/median
interface MedianAbstract {
    function WARDS9(address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function RELY664(address) external;	//inject NONSTANDARD NAMING
    function DENY283(address) external;	//inject NONSTANDARD NAMING
    function AGE221() external view returns (uint32);	//inject NONSTANDARD NAMING
    function WAT475() external view returns (bytes32);	//inject NONSTANDARD NAMING
    function BAR501() external view returns (uint256);	//inject NONSTANDARD NAMING
    function ORCL736(address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function BUD134(address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function SLOT890(uint8) external view returns (address);	//inject NONSTANDARD NAMING
    function READ871() external view returns (uint256);	//inject NONSTANDARD NAMING
    function PEEK743() external view returns (uint256, bool);	//inject NONSTANDARD NAMING
    function LIFT208(address[] calldata) external;	//inject NONSTANDARD NAMING
    function DROP945(address[] calldata) external;	//inject NONSTANDARD NAMING
    function SETBAR416(uint256) external;	//inject NONSTANDARD NAMING
    function KISS951(address) external;	//inject NONSTANDARD NAMING
    function DISS455(address) external;	//inject NONSTANDARD NAMING
    function KISS951(address[] calldata) external;	//inject NONSTANDARD NAMING
    function DISS455(address[] calldata) external;	//inject NONSTANDARD NAMING
    function POKE311(uint256[] calldata, uint256[] calldata, uint8[] calldata, bytes32[] calldata, bytes32[] calldata) external;	//inject NONSTANDARD NAMING
}

                                                  
                               

// https://github.com/makerdao/dss/blob/master/src/spot.sol
interface SpotAbstract {
    function WARDS9(address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function RELY664(address) external;	//inject NONSTANDARD NAMING
    function DENY283(address) external;	//inject NONSTANDARD NAMING
    function ILKS778(bytes32) external view returns (address, uint256);	//inject NONSTANDARD NAMING
    function VAT142() external view returns (address);	//inject NONSTANDARD NAMING
    function PAR826() external view returns (uint256);	//inject NONSTANDARD NAMING
    function LIVE534() external view returns (uint256);	//inject NONSTANDARD NAMING
    function FILE40(bytes32, bytes32, address) external;	//inject NONSTANDARD NAMING
    function FILE40(bytes32, uint256) external;	//inject NONSTANDARD NAMING
    function FILE40(bytes32, bytes32, uint256) external;	//inject NONSTANDARD NAMING
    function POKE311(bytes32) external;	//inject NONSTANDARD NAMING
    function CAGE3() external;	//inject NONSTANDARD NAMING
}

                                                 
                               

// https://github.com/makerdao/dss/blob/master/src/vat.sol
interface VatAbstract {
    function WARDS9(address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function RELY664(address) external;	//inject NONSTANDARD NAMING
    function DENY283(address) external;	//inject NONSTANDARD NAMING
    function CAN343(address, address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function HOPE769(address) external;	//inject NONSTANDARD NAMING
    function NOPE162(address) external;	//inject NONSTANDARD NAMING
    function ILKS778(bytes32) external view returns (uint256, uint256, uint256, uint256, uint256);	//inject NONSTANDARD NAMING
    function URNS690(bytes32, address) external view returns (uint256, uint256);	//inject NONSTANDARD NAMING
    function GEM16(bytes32, address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function DAI867(address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function SIN509(address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function DEBT851() external view returns (uint256);	//inject NONSTANDARD NAMING
    function VICE72() external view returns (uint256);	//inject NONSTANDARD NAMING
    function LINE452() external view returns (uint256);	//inject NONSTANDARD NAMING
    function LIVE534() external view returns (uint256);	//inject NONSTANDARD NAMING
    function INIT893(bytes32) external;	//inject NONSTANDARD NAMING
    function FILE40(bytes32, uint256) external;	//inject NONSTANDARD NAMING
    function FILE40(bytes32, bytes32, uint256) external;	//inject NONSTANDARD NAMING
    function CAGE3() external;	//inject NONSTANDARD NAMING
    function SLIP467(bytes32, address, int256) external;	//inject NONSTANDARD NAMING
    function FLUX370(bytes32, address, address, uint256) external;	//inject NONSTANDARD NAMING
    function MOVE182(address, address, uint256) external;	//inject NONSTANDARD NAMING
    function FROB273(bytes32, address, address, address, int256, int256) external;	//inject NONSTANDARD NAMING
    function FORK393(bytes32, address, address, int256, int256) external;	//inject NONSTANDARD NAMING
    function GRAB4(bytes32, address, address, address, int256, int256) external;	//inject NONSTANDARD NAMING
    function HEAL121(uint256) external;	//inject NONSTANDARD NAMING
    function SUCK524(address, address, uint256) external;	//inject NONSTANDARD NAMING
    function FOLD129(bytes32, address, int256) external;	//inject NONSTANDARD NAMING
}

                       
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

                             

                                                               

                                                          
                                                             
                                                           
                                                          

// TODO: add to dss-interfaces?
interface GemJoin6Like {
    function SETIMPLEMENTATION850(address, uint256) external;	//inject NONSTANDARD NAMING
}

contract SpellAction {

    // MAINNET ADDRESSES
    //
    // The contracts in this list should correspond to MCD core contracts, verify
    // against the current release list at:
    //     https://changelog.makerdao.com/releases/mainnet/1.1.1/contracts.json
    address constant mcd_join_tusd_a973  = 0x4454aF7C8bb9463203b66C816220D41ED7837f44;	//inject NONSTANDARD NAMING
    address constant mcd_jug931          = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;	//inject NONSTANDARD NAMING
    address constant mcd_spot639         = 0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3;	//inject NONSTANDARD NAMING
    address constant mcd_vat427          = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;	//inject NONSTANDARD NAMING
    address constant tusd_impl_new757    = 0x7a9701453249e84fd0D5AfE5951e9cBe9ed2E90f;	//inject NONSTANDARD NAMING
    address constant median_manausd649   = 0x681c4F8f69cF68852BAd092086ffEaB31F5B812c;	//inject NONSTANDARD NAMING
    address constant gitcoin_feed_old89 = 0xA4188B523EccECFbAC49855eB52eA0b55c4d56dd;	//inject NONSTANDARD NAMING
    address constant gitcoin_feed_new879 = 0x77EB6CF8d732fe4D92c427fCdd83142DB3B742f7;	//inject NONSTANDARD NAMING

    // Decimals & precision
    uint256 constant thousand409 = 10 ** 3;	//inject NONSTANDARD NAMING
    uint256 constant million93  = 10 ** 6;	//inject NONSTANDARD NAMING
    uint256 constant wad294      = 10 ** 18;	//inject NONSTANDARD NAMING
    uint256 constant ray683      = 10 ** 27;	//inject NONSTANDARD NAMING
    uint256 constant rad264      = 10 ** 45;	//inject NONSTANDARD NAMING

    // Many of the settings that change weekly rely on the rate accumulator
    // described at https://docs.makerdao.com/smart-contract-modules/rates-module
    // To check this yourself, use the following rate calculation (example 8%):
    //
    // $ bc -l <<< 'scale=27; e( l(1.08)/(60 * 60 * 24 * 365) )'
    //
    uint256 constant four_pct_rate701   = 1000000001243680656318820312;	//inject NONSTANDARD NAMING
    uint256 constant eight_pct_rate301  = 1000000002440418608258400030;	//inject NONSTANDARD NAMING
    uint256 constant twelve_pct_rate857 = 1000000003593629043335673582;	//inject NONSTANDARD NAMING
    uint256 constant fifty_pct_rate325  = 1000000012857214317438491659;	//inject NONSTANDARD NAMING

    function EXECUTE44() external {	//inject NONSTANDARD NAMING
                                            

        // Set the global debt ceiling to 1,196,000,000
        // 948 (current DC) + 200 (USDC-A increase) + 48 (TUSD-A increase)
        VatAbstract(mcd_vat427).FILE40("Line", 1196 * million93 * rad264);

        // Set the USDC-A debt ceiling
        //
        // Existing debt ceiling: 200 million
        // New debt ceiling: 400 million
        VatAbstract(mcd_vat427).FILE40("USDC-A", "line", 400 * million93 * rad264);

        // Set the TUSD-A debt ceiling
        //
        // Existing debt ceiling: 2 million
        // New debt ceiling: 50 million
        VatAbstract(mcd_vat427).FILE40("TUSD-A", "line", 50 * million93 * rad264);

        // Set USDC-A collateralization ratio
        //
        // Existing ratio: 103%
        // New ratio: 101%
        SpotAbstract(mcd_spot639).FILE40("USDC-A", "mat", 101 * ray683 / 100); // 101% coll. ratio
        SpotAbstract(mcd_spot639).POKE311("USDC-A");

        // Set TUSD-A collateralization ratio
        //
        // Existing ratio: 120%
        // New ratio: 101%
        SpotAbstract(mcd_spot639).FILE40("TUSD-A", "mat", 101 * ray683 / 100); // 101% coll. ratio
        SpotAbstract(mcd_spot639).POKE311("TUSD-A");

        // Set PAXUSD-A collateralization ratio
        //
        // Existing ratio: 103%
        // New ratio: 101%
        SpotAbstract(mcd_spot639).FILE40("PAXUSD-A", "mat", 101 * ray683 / 100); // 101% coll. ratio
        SpotAbstract(mcd_spot639).POKE311("PAXUSD-A");

        // Set the BAT-A stability fee
        //
        // Previous: 2%
        // New: 4%
        JugAbstract(mcd_jug931).DRIP219("BAT-A"); // drip right before
        JugAbstract(mcd_jug931).FILE40("BAT-A", "duty", four_pct_rate701);

        // Set the USDC-A stability fee
        //
        // Previous: 2%
        // New: 4%
        JugAbstract(mcd_jug931).DRIP219("USDC-A"); // drip right before
        JugAbstract(mcd_jug931).FILE40("USDC-A", "duty", four_pct_rate701);

        // Set the USDC-B stability fee
        //
        // Previous: 48%
        // New: 50%
        JugAbstract(mcd_jug931).DRIP219("USDC-B"); // drip right before
        JugAbstract(mcd_jug931).FILE40("USDC-B", "duty", fifty_pct_rate325);

        // Set the WBTC-A stability fee
        //
        // Previous: 2%
        // New: 4%
        JugAbstract(mcd_jug931).DRIP219("WBTC-A"); // drip right before
        JugAbstract(mcd_jug931).FILE40("WBTC-A", "duty", four_pct_rate701);

        // Set the TUSD-A stability fee
        //
        // Previous: 0%
        // New: 4%
        JugAbstract(mcd_jug931).DRIP219("TUSD-A"); // drip right before
        JugAbstract(mcd_jug931).FILE40("TUSD-A", "duty", four_pct_rate701);

        // Set the KNC-A stability fee
        //
        // Previous: 2%
        // New: 4%
        JugAbstract(mcd_jug931).DRIP219("KNC-A"); // drip right before
        JugAbstract(mcd_jug931).FILE40("KNC-A", "duty", four_pct_rate701);

        // Set the ZRX-A stability fee
        //
        // Previous: 2%
        // New: 4%
        JugAbstract(mcd_jug931).DRIP219("ZRX-A"); // drip right before
        JugAbstract(mcd_jug931).FILE40("ZRX-A", "duty", four_pct_rate701);

        // Set the MANA-A stability fee
        //
        // Previous: 10%
        // New: 12%
        JugAbstract(mcd_jug931).DRIP219("MANA-A"); // drip right before
        JugAbstract(mcd_jug931).FILE40("MANA-A", "duty", twelve_pct_rate857);

        // Set the USDT-A stability fee
        //
        // Previous: 6%
        // New: 8%
        JugAbstract(mcd_jug931).DRIP219("USDT-A"); // drip right before
        JugAbstract(mcd_jug931).FILE40("USDT-A", "duty", eight_pct_rate301);

        // Set the PAXUSD-A stability fee
        //
        // Previous: 2%
        // New: 4%
        JugAbstract(mcd_jug931).DRIP219("PAXUSD-A"); // drip right before
        JugAbstract(mcd_jug931).FILE40("PAXUSD-A", "duty", four_pct_rate701);

                                     

        // Whitelist new TUSD implementation
        GemJoin6Like(mcd_join_tusd_a973).SETIMPLEMENTATION850(tusd_impl_new757, 1);        

        // Replace Gitcoin feed key on MANAUSD Oracle
        address[] memory drops = new address[](1);
        drops[0] = gitcoin_feed_old89;
        MedianAbstract(median_manausd649).DROP945(drops);

        address[] memory lifts = new address[](1);
        lifts[0] = gitcoin_feed_new879;
        MedianAbstract(median_manausd649).LIFT208(lifts);
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

    // Provides a descriptive tag for bot consumption
    // This should be modified weekly to provide a summary of the actions
    // Hash: seth keccak -- "$(wget https://raw.githubusercontent.com/makerdao/community/9fe29a1704a7885305774bbb31ab04fedd363259/governance/votes/Executive%20vote%20-%20September%2018%2C%202020.md -q -O - 2>/dev/null)"
    string constant public description372 =	//inject NONSTANDARD NAMING
        "2020-09-18 MakerDAO Executive Spell | Hash: 0xe942f72e80295685e39e303f8979560523beae8569daccfcea2f000b14a14abf";

    constructor() public {
        sig = abi.encodeWithSignature("execute()");
        action = address(new SpellAction());
        bytes32 _tag;
        address _action = action;
        assembly { _tag := extcodehash(_action) }
        tag = _tag;
        expiration = now + 30 days;
    }

    // modifier officeHours {
    //     uint day = (now / 1 days + 3) % 7;
    //     require(day < 5, "Can only be cast on a weekday");
    //     uint hour = now / 1 hours % 24;
    //     require(hour >= 14 && hour < 21, "Outside office hours");
    //     _;
    // }

    function SCHEDULE830() public {	//inject NONSTANDARD NAMING
        require(now <= expiration, "This contract has expired");
        require(eta == 0, "This spell has already been scheduled");
        eta = now + DSPauseAbstract(pause).DELAY460();
        pause.PLOT131(action, tag, sig, eta);
    }

    function CAST998() public                 {	//inject NONSTANDARD NAMING
        require(!done, "spell-already-cast");
        done = true;
        pause.EXEC84(action, tag, sig, eta);
    }
}