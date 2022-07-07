/**
 *Submitted for verification at Etherscan.io on 2020-02-21
*/

pragma solidity 0.5.12;

//import "ds-math/math.sol";
contract DSMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function min(uint x, uint y) internal pure returns (uint z) {
        return x <= y ? x : y;
    }
    function max(uint x, uint y) internal pure returns (uint z) {
        return x >= y ? x : y;
    }
    function imin(int x, int y) internal pure returns (int z) {
        return x <= y ? x : y;
    }
    function imax(int x, int y) internal pure returns (int z) {
        return x >= y ? x : y;
    }

    uint constant WAD = 10 ** 18;
    uint constant RAY = 10 ** 27;

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }
    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }
    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, RAY), y / 2) / y;
    }

    // This famous algorithm is called "exponentiation by squaring"
    // and calculates x^n with x as fixed-point and n as regular unsigned.
    //
    // It's O(log n), instead of O(n) for naive repeated multiplication.
    //
    // These facts are why it works:
    //
    //  If n is even, then x^n = (x^2)^(n/2).
    //  If n is odd,  then x^n = x * x^(n-1),
    //   and applying the equation for even x gives
    //    x^n = x * (x^2)^((n-1) / 2).
    //
    //  Also, EVM division is flooring and
    //    floor[(n-1) / 2] = floor[n / 2].
    //
    function rpow(uint x, uint n) internal pure returns (uint z) {
        z = n % 2 != 0 ? x : RAY;

        for (n /= 2; n != 0; n /= 2) {
            x = rmul(x, x);

            if (n % 2 != 0) {
                z = rmul(z, x);
            }
        }
    }
}

//import "lib/dss-interfaces/src/dapp/DSPauseAbstract.sol";
// https://github.com/dapphub/ds-pause
contract DSPauseAbstract {
    function setOwner(address) public;
    // setAuthority address should conform to DSAuthorityAbstract
    function setAuthority(address) public;
    function setDelay(uint256) public;
    // mapping (bytes32 => bool) public plans;
    function plans(bytes32) public view returns (bool);
    // DSPauseProxyAbstract public proxy;
    function proxy() public view returns (address);
    // uint256 public delay;
    function delay() public view returns (uint256);
    function plot(address, bytes32, bytes memory, uint256) public;
    function drop(address, bytes32, bytes memory, uint256) public;
    function exec(address, bytes32, bytes memory, uint256) public returns (bytes memory);
}

//import "lib/dss-interfaces/src/dss/OsmAbstract.sol";
// https://github.com/makerdao/osm
contract OsmAbstract {
    // mapping (address => uint) public wards;
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    // uint256 public stopped;
    function stopped() public view returns (uint256);
    // address public src;
    function src() public view returns (address);
    // uint16  constant ONE_HOUR = uint16(3600);
    function ONE_HOUR() public view returns (uint16);
    // uint16  public hop = ONE_HOUR;
    function hop() public view returns (uint16);
    // uint64  public zzz;
    function zzz() public view returns (uint64);
    struct Feed {
        uint128 val;
        uint128 has;
    }
    // Feed cur;
    function cur() public view returns (uint128, uint128);
    // Feed nxt;
    function nxt() public view returns (uint128, uint128);
    // mapping (address => uint256) public bud;
    function bud(address) public view returns (uint256);
    event LogValue(bytes32);
    function stop() external;
    function start() external;
    function change(address) external;
    function step(uint16) external;
    function void() external;
    function pass() public view returns (bool);
    function poke() external;
    function peek() external view returns (bytes32, bool);
    function peep() external view returns (bytes32, bool);
    function read() external view returns (bytes32);
    function kiss(address) external;
    function diss(address) external;
    function kiss(address[] calldata) external;
    function diss(address[] calldata) external;
}

//import "lib/dss-interfaces/src/dss/OsmMomAbstract.sol";
// https://github.com/makerdao/osm-mom
contract OsmMomAbstract {
    // address public owner;
    function owner() public view returns (address);
    // address public authority;
    function authority() public view returns (address);
    // mapping (bytes32 => address) public osms;
    function osms(bytes32) public view returns (address);
    function setOsm(bytes32, address) public;
    function setOwner(address) public;
    function setAuthority(address) public;
    function stop(bytes32) public;
}

//import "lib/dss-interfaces/src/dss/JugAbstract.sol";
// https://github.com/makerdao/dss/blob/master/src/jug.sol
contract JugAbstract {
    // mapping (address => uint) public wards;
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    struct Ilk {
        uint256 duty;
        uint256  rho;
    }
    // mapping (bytes32 => Ilk) public ilks;
    function ilks(bytes32) public view returns (uint256, uint256);
    // VatLike public vat;
    function vat() public view returns (address);
    // address public vow;
    function vow() public view returns (address);
    // uint256 public base;
    function base() public view returns (address);
    // uint256 constant ONE = 10 ** 27;
    function ONE() public view returns (uint256);
    function init(bytes32) external;
    function file(bytes32, bytes32, uint256) external;
    function file(bytes32, uint256) external;
    function file(bytes32, address) external;
    function drip(bytes32) external returns (uint256);
}

//import "lib/dss-interfaces/src/dss/PotAbstract.sol";
// https://github.com/makerdao/dss/blob/master/src/pot.sol
contract PotAbstract {
    // mapping (address => uint256) public wards;
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    // mapping (address => uint256) public pie;  // user Savings Dai
    function pie(address) public view returns (uint256);
    // uint256 public Pie;  // total Savings Dai
    function Pie() public view returns (uint256);
    // uint256 public dsr;  // the Dai Savings Rate
    function dsr() public view returns (uint256);
    // uint256 public chi;  // the Rate Accumulator
    function chi() public view returns (uint256);
    // VatAbstract public vat;  // CDP engine
    function vat() public view returns (address);
    // address public vow;  // debt engine
    function vow() public view returns (address);
    // uint256 public rho;  // time of last drip
    function rho() public view returns (uint256);
    // uint256 public live;  // Access Flag
    function live() public view returns (uint256);
    function file(bytes32, uint256) external;
    function file(bytes32, address) external;
    function cage() external;
    function drip() external returns (uint256);
    function join(uint256) external;
    function exit(uint256) external;
}

//import "lib/dss-interfaces/src/dss/VatAbstract.sol";
// https://github.com/makerdao/dss/blob/master/src/vat.sol
contract VatAbstract {
    // mapping (address => uint) public wards;
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    struct Ilk {
        uint256 Art;   // Total Normalised Debt     [wad]
        uint256 rate;  // Accumulated Rates         [ray]
        uint256 spot;  // Price with Safety Margin  [ray]
        uint256 line;  // Debt Ceiling              [rad]
        uint256 dust;  // Urn Debt Floor            [rad]
    }
    struct Urn {
        uint256 ink;   // Locked Collateral  [wad]
        uint256 art;   // Normalised Debt    [wad]
    }
    // mapping (address => mapping (address => uint256)) public can;
    function can(address, address) public view returns (uint256);
    function hope(address) external;
    function nope(address) external;
    // mapping (bytes32 => Ilk) public ilks;
    function ilks(bytes32) external view returns (uint256, uint256, uint256, uint256, uint256);
    // mapping (bytes32 => mapping (address => Urn)) public urns;
    function urns(bytes32, address) public view returns (uint256, uint256);
    // mapping (bytes32 => mapping (address => uint256)) public gem;  // [wad]
    function gem(bytes32, address) public view returns (uint256);
    // mapping (address => uint256) public dai;  // [rad]
    function dai(address) public view returns (uint256);
    // mapping (address => uint256) public sin;  // [rad]
    function sin(address) public view returns (uint256);
    // uint256 public debt;  // Total Dai Issued    [rad]
    function debt() public view returns (uint256);
    // uint256 public vice;  // Total Unbacked Dai  [rad]
    function vice() public view returns (uint256);
    // uint256 public Line;  // Total Debt Ceiling  [rad]
    function Line() public view returns (uint256);
    // uint256 public live;  // Access Flag
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

//import "lib/dss-interfaces/src/dss/FlapAbstract.sol";
// https://github.com/makerdao/dss/blob/master/src/flap.sol
contract FlapAbstract {
    //mapping (address => uint256) public wards;
    function wards(address) public view returns (uint256);
    function rely(address) external;
    function deny(address) external;
    struct Bid {
        uint256 bid;
        uint256 lot;
        address guy;  // high bidder
        uint48  tic;  // expiry time
        uint48  end;
    }
    // mapping (uint256 => Bid) public bids;
    function bids(uint256) public view returns (uint256);
    // VatAbstract public vat;
    function vat() public view returns (address);
    // TokenAbstract public gem;
    // gem return address will conform to DSTokenAbstract
    function gem() public view returns (address);
    // uint256 public ONE;
    function ONE() public view returns (uint256);
    // uint256 public beg;
    function beg() public view returns (uint256);
    // uint48 public ttl;
    function ttl() public view returns (uint48);
    // uint48 public tau;
    function tau() public view returns (uint48);
    // uint256 public kicks;
    function kicks() public view returns (uint256);
    // uint256 public live;
    function live() public view returns (uint256);
    event Kick(uint256, uint256, uint256);
    function file(bytes32, uint256) external;
    function kick(uint256, uint256) external returns (uint256);
    function tick(uint256) external;
    function tend(uint256, uint256, uint256) external;
    function deal(uint256) external;
    function cage(uint256) external;
    function yank(uint256) external;
}

//import "lib/dss-interfaces/src/sai/SaiMomAbstract.sol";
// https://github.com/makerdao/sai/blob/master/src/mom.sol
contract SaiMomAbstract {
    // SaiTub  public  tub;
    function tub() public view returns (address);
    // SaiTap  public  tap;
    function tap() public view returns (address);
    // SaiVox  public  vox;
    function vox() public view returns (address);
    function setCap(uint256) public;                  // Debt ceiling
    function setMat(uint256) public;                  // Liquidation ratio
    function setTax(uint256) public;                  // Stability fee
    function setFee(uint256) public;                  // Governance fee
    function setAxe(uint256) public;                  // Liquidation fee
    function setTubGap(uint256) public;               // Join/Exit Spread
    function setPip(address) public;                  // ETH/USD Feed
    function setPep(address) public;                  // MKR/USD Feed
    function setVox(address) public;                  // TRFM
    function setTapGap(uint256) public;               // Boom/Bust Spread
    function setWay(uint256) public;                  // Rate of change of target price (per second)
    function setHow(uint256) public;
    // ds-thing
    // DSAuthority  public  authority;
    function authority() public view returns (address);
    // address      public  owner;
    function owner() public view returns (address);
    function setOwner(address) public;
    function setAuthority(address) public;
}


contract SpellAction is DSMath {
    uint256 constant RAD = 10 ** 45;
    address constant public PAUSE = 0xbE286431454714F511008713973d3B053A2d38f3;
    address constant public CHIEF = 0x9eF05f7F6deB616fd37aC3c959a2dDD25A54E4F5;
    address constant public OSM_MOM = 0x76416A4d5190d071bfed309861527431304aA14f;
    address constant public ETH_OSM = 0x81FE72B5A8d1A857d176C3E7d5Bd2679A9B85763;
    address constant public BAT_OSM = 0xB4eb54AF9Cc7882DF0121d26c5b97E802915ABe6;
    address constant public VAT = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address constant public JUG = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
    address constant public POT = 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7;
    address constant public FLAP = 0xdfE0fb1bE2a52CDBf8FB962D5701d7fd0902db9f;
    uint256 constant NEW_BEG = 1.02E18; // 2%

    function execute() external {
        // drip
        PotAbstract(POT).drip();
        JugAbstract(JUG).drip("ETH-A");
        JugAbstract(JUG).drip("BAT-A");

        // set the global debt ceiling to 183,000,000
        VatAbstract(VAT).file("Line", mul(183000000, RAD));

        // set the ETH-A debt ceiling to 150,000,000
        // https://vote.makerdao.com/polling-proposal/qmsm1q1hohyctsgxpbm44fomjoukf1d5g9lmpqraikmeoc
        VatAbstract(VAT).file("ETH-A", "line", mul(150000000, RAD));

        // No Sai debt ceiling change this week.

        // set dsr to 8.0%
        // Previously ETH SF was set to 8.0%, no change this week.
        //  DSR rate was voted to a 0% spread, so we're bringing DSR up to match.
        // https://vote.makerdao.com/polling-proposal/qmss9hnszwr6egq3xn6gpx4u8bz8cajja56rgtanjev1v8
        PotAbstract(POT).file("dsr", 1000000002440418608258400030);

        // MCD Stability fee is currently at 8% and remains the same this week.
        // https://vote.makerdao.com/polling-proposal/qmzgvzjm4xpm4b1tk2hxhdc6p8f4zqyju38pwqieatmhel

        // Lower the minimum flap auction bid increase to 2%
        // https://vote.makerdao.com/polling-proposal/qmtsxrqavtczfsseytpypgqrz6z8zb613ikxwhqjv9ytzz
        FlapAbstract(FLAP).file("beg", NEW_BEG);

        // Increase the Pause to 24 Hours
        OsmAbstract(ETH_OSM).rely(OSM_MOM);
        OsmAbstract(BAT_OSM).rely(OSM_MOM);
        OsmMomAbstract(OSM_MOM).setAuthority(CHIEF);
        OsmMomAbstract(OSM_MOM).setOsm("ETH-A", ETH_OSM);
        OsmMomAbstract(OSM_MOM).setOsm("BAT-A", BAT_OSM);
        DSPauseAbstract(PAUSE).setDelay(60 * 60 * 24);
    }
}

contract DssSpell20200221 is DSMath {
    DSPauseAbstract  public pause ;	//inject UNINIT LOCAL/STATE VAR

    address constant public SAIMOM = 0xF2C5369cFFb8Ea6284452b0326e326DbFdCb867C;
    uint256 constant public NEW_FEE = 1000000002877801985002875644; // 9.5%
    address          public action;
    bytes32          public tag;
    uint256          public eta;
    bytes            public sig;
    bool             public done;

    constructor() public {
        sig = abi.encodeWithSignature("execute()");
        action = address(new SpellAction());
        bytes32 _tag;
        address _action ;	//inject UNINIT LOCAL/STATE VAR

        assembly { _tag := extcodehash(_action) }
        tag = _tag;
    }

    function schedule() public {
        require(eta == 0, "spell-already-scheduled");
        eta = add(now, DSPauseAbstract(pause).delay());
        pause.plot(action, tag, sig, eta);

        // NOTE: 'eta' check should mimic the old behavior of 'done', thus
        // preventing these SCD changes from being executed again.

        // Sai Stability Fee adjustment to 9.5%
        // https://vote.makerdao.com/polling-proposal/qmaj4fnjeohomnrs8m9cihrfxws4m89bwfu9eh96y8okxw
        SaiMomAbstract(SAIMOM).setFee(NEW_FEE);
    }

    function cast() public {
        require(!done, "spell-already-cast");
        done = true;
        pause.exec(action, tag, sig, eta);
    }
}