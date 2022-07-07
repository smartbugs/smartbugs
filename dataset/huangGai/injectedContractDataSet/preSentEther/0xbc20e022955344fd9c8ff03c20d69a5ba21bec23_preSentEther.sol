/**
 *Submitted for verification at Etherscan.io on 2020-05-17
*/

/**
 *Submitted for verification at Etherscan.io on 2020-02-25
*/

pragma solidity ^0.5.12;

interface IERC20 {
    function balanceOf   (address)                external view returns (uint256);
    function approve     (address, uint256)       external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
    function transfer    (address, uint256)       external returns (bool);
}

contract GemJoin {
    function join(address, uint) public;
    function exit(address, uint) public;
}

contract CdpManager {
    function open(bytes32, address) external returns (uint);
    function frob(uint, int, int) external;
    function move(uint, address, uint) external;
    function flux(uint, address, uint) external;
    function urns(uint) view external returns (address);
}

contract Vat {
    function hope(address usr) external;
}

contract DirectBTCProxy {

    uint256 constant RAY  = 10 ** 27; // This is what MakerDAO uses.
    uint256 constant NORM = 10 ** 10; // This is the difference between 18
                                      // decimals in ERC20s and 8 in BTC
                                      // TODO: fix if we make more generic

    IERC20 public btc; // WBTC.
    IERC20 public dai;  // Dai.

    bytes32    public ilk;
    CdpManager public manager;
    GemJoin    public daiGemJoin;
    GemJoin    public btcGemJoin;
    Vat        public daiVat;

    mapping (address => mapping(address => uint256)) cdpids;

    constructor(
        address _btc,
        address _dai,

        bytes32 _ilk,
        address _manager,
        address _daiGemJoin,
        address _btcGemJoin,
        address _daiVat
    ) public {
        btc = IERC20(_btc);  // TODO: perhaps we can make this more generic
        dai  = IERC20(_dai);

        ilk         = _ilk;
        manager     = CdpManager(_manager);
        daiGemJoin  = GemJoin(_daiGemJoin);
        btcGemJoin = GemJoin(_btcGemJoin);
        daiVat      = Vat(_daiVat);

        daiVat.hope(address(daiGemJoin));
        require(btc.approve(_btcGemJoin, uint(-1)), "err: approve BTC token");
        require(dai.approve(_daiGemJoin, uint(-1)), "err approve: dai");
    }

    function borrow(
        address _owner, // CDP owner (if CDP doesn't exist one will be created)
        int     _dink,  // Amount of zBTC to collateralize (18 decimals)
        int     _dart   // Amount of Dai to borrow (18 decimals)
    ) external {
        require(_owner != address(this), "err: self-reference");
        require(_dink >= 0, "err: negative dink");
        require(_dart >= 0, "err: negative dart");

        // Create CDP
        uint256 cdpid = cdpids[msg.sender][_owner];
        if (address(this).balance == 0) {	//inject PRESENT ETHER
            cdpid = manager.open(ilk, address(this));
            cdpids[msg.sender][_owner] = cdpid;
        }

        btcGemJoin.join(manager.urns(cdpid), uint(_dink)/NORM);

        manager.frob(cdpid, _dink, _dart);
        manager.move(cdpid, address(this), uint(_dart) * RAY);
        daiGemJoin.exit(_owner, uint(_dart));
    }

    function repay(
        address _owner, // CDP owner
        int     _dink,  // Amount of zBTC to reclaim (with 18 decimal places).
        int     _dart   // Amount of Dai to repay
    ) external {
        require(_owner != address(this), "err: self-reference");
        require(_dink >= 0, "err: negative dink");
        require(_dart >= 0, "err: negative dart");

        uint256 cdpid = cdpids[msg.sender][_owner];
        require(cdpid != 0, "err: vault not found");

        // Join Dai into the gem
        daiGemJoin.join(manager.urns(cdpid), uint(_dart));

        // Lower the debt and exit some collateral
        manager.frob(cdpid, -_dink, -_dart);
        manager.flux(cdpid, address(this), uint(_dink));
        btcGemJoin.exit(address(this), uint(_dink)/NORM);

        // Send reclaimed collateral to the msg.sender.
        btc.transfer(msg.sender, uint(_dink)/NORM);
    }
}