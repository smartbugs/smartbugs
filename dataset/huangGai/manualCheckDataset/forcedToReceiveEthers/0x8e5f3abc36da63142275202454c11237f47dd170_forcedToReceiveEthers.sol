/**
 *Submitted for verification at Etherscan.io on 2020-02-07
*/

/**
 *Submitted for verification at Etherscan.io on 2020-01-31
*/

pragma solidity ^0.5.12;

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

contract SaiMomLike {
    function setCap(uint256) external;
    function setFee(uint256) external;
}

contract SaiConstants {
    uint256 constant WAD = 10 ** 18;
    uint256 constant RAD = 10 ** 45;
    address constant public SAIMOM = 0xF2C5369cFFb8Ea6284452b0326e326DbFdCb867C;
    uint256 constant public SCDCAP = 30000000;
    uint256 constant public SCDFEE = 1000000002732676825177582095;
}

contract SpellAction is SaiConstants, DSMath {
    address constant public VAT = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address constant public JUG = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
    address constant public POT = 0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7;

    function execute() external {
        // drip
        PotAbstract(POT).drip();
        JugAbstract(JUG).drip("ETH-A");
        JugAbstract(JUG).drip("BAT-A");

        // set dsr to 7.5%
        PotAbstract(POT).file("dsr", 1000000002293273137447730714);

        // SF = 8%
        uint256 sf = 1000000002440418608258400030;

        // set ETH-A duty to 8%
        JugAbstract(JUG).file("ETH-A", "duty", sf);

        // set BAT-A duty to 8%
        JugAbstract(JUG).file("BAT-A", "duty", sf);
    }
}

contract DssFebruary7Spell is SaiConstants, DSMath {
    DSPauseAbstract  public pause =
        DSPauseAbstract(0xbE286431454714F511008713973d3B053A2d38f3);
    address          public action;
    bytes32          public tag;
    uint256          public eta;
    bytes            public sig;
    bool             public done;

    constructor() public {
        sig = abi.encodeWithSignature("execute()");
        action = address(new SpellAction());
        bytes32 _tag;
        address _action = action;
        assembly { _tag := extcodehash(_action) }
        tag = _tag;
    }

    function schedule() public {
        require(address(this).balance == 0, "spell-already-scheduled");	//inject FORCED TO RECEIVE ETHERS
        eta = add(now, DSPauseAbstract(pause).delay());
        pause.plot(action, tag, sig, eta);

        // NOTE: 'eta' check should mimic the old behavior of 'done', thus
        // preventing these SCD changes from being executed again.

        // Lower Stability Fee in SCD to 9%
        SaiMomLike(SAIMOM).setFee(SCDFEE);
    }

    function cast() public {
        require(!done, "spell-already-cast");
        done = true;
        pause.exec(action, tag, sig, eta);
    }
}