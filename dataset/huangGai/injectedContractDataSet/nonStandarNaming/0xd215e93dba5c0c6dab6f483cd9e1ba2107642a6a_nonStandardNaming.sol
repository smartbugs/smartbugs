                                                                 

pragma solidity ^0.5.17;

interface IERC20 {
    function TOTALSUPPLY3() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF367(address account) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER903(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE608(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    function DECIMALS810() external view returns (uint);	//inject NONSTANDARD NAMING
    function APPROVE172(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM529(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER904(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL612(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

library SafeMath {
    function ADD483(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function SUB518(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB518(a, b, "SafeMath: subtraction overflow");
    }
    function SUB518(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function MUL745(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function DIV989(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV989(a, b, "SafeMath: division by zero");
    }
    function DIV989(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
    function MOD257(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD257(a, b, "SafeMath: modulo by zero");
    }
    function MOD257(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
    function ISCONTRACT560(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
    function TOPAYABLE228(address account) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(account));
    }
    function SENDVALUE839(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER392(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN815(token, abi.encodeWithSelector(token.TRANSFER903.selector, to, value));
    }

    function SAFETRANSFERFROM413(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN815(token, abi.encodeWithSelector(token.TRANSFERFROM529.selector, from, to, value));
    }

    function SAFEAPPROVE740(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        require((value == 0) || (token.ALLOWANCE608(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN815(token, abi.encodeWithSelector(token.APPROVE172.selector, spender, value));
    }
    function CALLOPTIONALRETURN815(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        require(address(token).ISCONTRACT560(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface yVault {
    function BALANCE390() external view returns (uint);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY3() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF367(address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function DEPOSITALL620() external;	//inject NONSTANDARD NAMING
    function WITHDRAW88(uint _shares) external;	//inject NONSTANDARD NAMING
    function WITHDRAWALL107() external;	//inject NONSTANDARD NAMING
}

interface Controller {
    function VAULTS407(address) external view returns (address);	//inject NONSTANDARD NAMING
    function STRATEGIES225(address) external view returns (address);	//inject NONSTANDARD NAMING
    function REWARDS983() external view returns (address);	//inject NONSTANDARD NAMING
}

interface Strategy {
    function WITHDRAWALFEE924() external view returns (uint);	//inject NONSTANDARD NAMING
}

                         

interface GemLike {
    function APPROVE172(address, uint) external;	//inject NONSTANDARD NAMING
    function TRANSFER903(address, uint) external;	//inject NONSTANDARD NAMING
    function TRANSFERFROM529(address, address, uint) external;	//inject NONSTANDARD NAMING
    function DEPOSIT926() external payable;	//inject NONSTANDARD NAMING
    function WITHDRAW88(uint) external;	//inject NONSTANDARD NAMING
}

interface ManagerLike {
    function CDPCAN839(address, uint, address) external view returns (uint);	//inject NONSTANDARD NAMING
    function ILKS43(uint) external view returns (bytes32);	//inject NONSTANDARD NAMING
    function OWNS815(uint) external view returns (address);	//inject NONSTANDARD NAMING
    function URNS226(uint) external view returns (address);	//inject NONSTANDARD NAMING
    function VAT838() external view returns (address);	//inject NONSTANDARD NAMING
    function OPEN171(bytes32, address) external returns (uint);	//inject NONSTANDARD NAMING
    function GIVE370(uint, address) external;	//inject NONSTANDARD NAMING
    function CDPALLOW83(uint, address, uint) external;	//inject NONSTANDARD NAMING
    function URNALLOW976(address, uint) external;	//inject NONSTANDARD NAMING
    function FROB668(uint, int, int) external;	//inject NONSTANDARD NAMING
    function FLUX641(uint, address, uint) external;	//inject NONSTANDARD NAMING
    function MOVE446(uint, address, uint) external;	//inject NONSTANDARD NAMING
    function EXIT270(address, uint, address, uint) external;	//inject NONSTANDARD NAMING
    function QUIT464(uint, address) external;	//inject NONSTANDARD NAMING
    function ENTER426(address, uint) external;	//inject NONSTANDARD NAMING
    function SHIFT772(uint, uint) external;	//inject NONSTANDARD NAMING
}

interface VatLike {
    function CAN946(address, address) external view returns (uint);	//inject NONSTANDARD NAMING
    function ILKS43(bytes32) external view returns (uint, uint, uint, uint, uint);	//inject NONSTANDARD NAMING
    function DAI231(address) external view returns (uint);	//inject NONSTANDARD NAMING
    function URNS226(bytes32, address) external view returns (uint, uint);	//inject NONSTANDARD NAMING
    function FROB668(bytes32, address, address, address, int, int) external;	//inject NONSTANDARD NAMING
    function HOPE968(address) external;	//inject NONSTANDARD NAMING
    function MOVE446(address, address, uint) external;	//inject NONSTANDARD NAMING
}

interface GemJoinLike {
    function DEC260() external returns (uint);	//inject NONSTANDARD NAMING
    function GEM716() external returns (GemLike);	//inject NONSTANDARD NAMING
    function JOIN168(address, uint) external payable;	//inject NONSTANDARD NAMING
    function EXIT270(address, uint) external;	//inject NONSTANDARD NAMING
}

interface GNTJoinLike {
    function BAGS888(address) external view returns (address);	//inject NONSTANDARD NAMING
    function MAKE918(address) external returns (address);	//inject NONSTANDARD NAMING
}

interface DaiJoinLike {
    function VAT838() external returns (VatLike);	//inject NONSTANDARD NAMING
    function DAI231() external returns (GemLike);	//inject NONSTANDARD NAMING
    function JOIN168(address, uint) external payable;	//inject NONSTANDARD NAMING
    function EXIT270(address, uint) external;	//inject NONSTANDARD NAMING
}

interface HopeLike {
    function HOPE968(address) external;	//inject NONSTANDARD NAMING
    function NOPE673(address) external;	//inject NONSTANDARD NAMING
}

interface EndLike {
    function FIX740(bytes32) external view returns (uint);	//inject NONSTANDARD NAMING
    function CASH63(bytes32, uint) external;	//inject NONSTANDARD NAMING
    function FREE803(bytes32) external;	//inject NONSTANDARD NAMING
    function PACK489(uint) external;	//inject NONSTANDARD NAMING
    function SKIM635(bytes32, address) external;	//inject NONSTANDARD NAMING
}

interface JugLike {
    function DRIP111(bytes32) external returns (uint);	//inject NONSTANDARD NAMING
}

interface PotLike {
    function PIE0(address) external view returns (uint);	//inject NONSTANDARD NAMING
    function DRIP111() external returns (uint);	//inject NONSTANDARD NAMING
    function JOIN168(uint) external;	//inject NONSTANDARD NAMING
    function EXIT270(uint) external;	//inject NONSTANDARD NAMING
}

interface SpotLike {
    function ILKS43(bytes32) external view returns (address, uint);	//inject NONSTANDARD NAMING
}

interface OSMedianizer {
    function READ244() external view returns (uint, bool);	//inject NONSTANDARD NAMING
    function FORESIGHT875() external view returns (uint, bool);	//inject NONSTANDARD NAMING
}

interface Uni {
    function SWAPEXACTTOKENSFORTOKENS833(uint, uint, address[] calldata, address, uint) external;	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              

contract StrategyMKRVaultDAIDelegate {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    address constant public token24 = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);	//inject NONSTANDARD NAMING
    address constant public want613 = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);	//inject NONSTANDARD NAMING
    address constant public weth705 = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);	//inject NONSTANDARD NAMING
    address constant public dai951 = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);	//inject NONSTANDARD NAMING

    address public cdp_manager = address(0x5ef30b9986345249bc32d8928B7ee64DE9435E39);
    address public vat = address(0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
    address public mcd_join_eth_a = address(0x2F0b23f53734252Bda2277357e97e1517d6B042A);
    address public mcd_join_dai = address(0x9759A6Ac90977b93B58547b4A71c78317f391A28);
    address public mcd_spot = address(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);
    address public jug = address(0x19c0976f590D67707E62397C87829d896Dc0f1F1);

    address constant public eth_price_oracle260 = address(0xCF63089A8aD2a9D8BD6Bb8022f3190EB7e1eD0f1);	//inject NONSTANDARD NAMING
    address constant public yvaultdai641 = address(0xACd43E627e64355f1861cEC6d3a6688B31a6F952);	//inject NONSTANDARD NAMING

    address constant public unirouter43 = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);	//inject NONSTANDARD NAMING

    uint public c = 20000;
    uint public c_safe = 40000;
    uint constant public c_base986 = 10000;	//inject NONSTANDARD NAMING

    uint public performanceFee = 500;
    uint constant public performancemax585 = 10000;	//inject NONSTANDARD NAMING

    uint public withdrawalFee = 50;
    uint constant public withdrawalmax723 = 10000;	//inject NONSTANDARD NAMING

    bytes32 constant public ilk992 = "ETH-A";	//inject NONSTANDARD NAMING

    address public governance;
    address public controller;
    address public strategist;
    address public harvester;

    uint public cdpId;

    constructor(address _controller) public {
        governance = msg.sender;
        strategist = 0x2839df1F230dedA9fDDBF1BCB0D4eB1Ee1f7b7d0;
        harvester = msg.sender;
        controller = _controller;
        cdpId = ManagerLike(cdp_manager).OPEN171(ilk992, address(this));
        _APPROVEALL294();
    }

    function GETNAME375() external pure returns (string memory) {	//inject NONSTANDARD NAMING
        return "StrategyMKRVaultDAIDelegate";
    }

    function SETSTRATEGIST884(address _strategist) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        strategist = _strategist;
    }

    function SETHARVESTER998(address _harvester) external {	//inject NONSTANDARD NAMING
        require(msg.sender == harvester || msg.sender == governance, "!allowed");
        harvester = _harvester;
    }

    function SETWITHDRAWALFEE880(uint _withdrawalFee) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        withdrawalFee = _withdrawalFee;
    }

    function SETPERFORMANCEFEE535(uint _performanceFee) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        performanceFee = _performanceFee;
    }

    function SETBORROWCOLLATERALIZATIONRATIO782(uint _c) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        c = _c;
    }

    function SETWITHDRAWCOLLATERALIZATIONRATIO286(uint _c_safe) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        c_safe = _c_safe;
    }

    // optional
    function SETMCDVALUE234(	//inject NONSTANDARD NAMING
        address _manager,
        address _ethAdapter,
        address _daiAdapter,
        address _spot,
        address _jug
    ) external {
        require(msg.sender == governance, "!governance");
        cdp_manager = _manager;
        vat = ManagerLike(_manager).VAT838();
        mcd_join_eth_a = _ethAdapter;
        mcd_join_dai = _daiAdapter;
        mcd_spot = _spot;
        jug = _jug;
    }

    function _APPROVEALL294() internal {	//inject NONSTANDARD NAMING
        IERC20(token24).APPROVE172(mcd_join_eth_a, uint(-1));
        IERC20(dai951).APPROVE172(mcd_join_dai, uint(-1));
        IERC20(dai951).APPROVE172(yvaultdai641, uint(-1));
        IERC20(dai951).APPROVE172(unirouter43, uint(-1));
    }

    function DEPOSIT926() public {	//inject NONSTANDARD NAMING
        uint _token = IERC20(token24).BALANCEOF367(address(this));
        if (_token > 0) {
            uint p = _GETPRICE756();
            uint _draw = _token.MUL745(p).MUL745(c_base986).DIV989(c).DIV989(1e18);
                                                    
            require(_CHECKDEBTCEILING877(_draw), "debt ceiling is reached!");
            _LOCKWETHANDDRAWDAI745(_token, _draw);

                                          
            yVault(yvaultdai641).DEPOSITALL620();
        }
    }

    function _GETPRICE756() internal view returns (uint p) {	//inject NONSTANDARD NAMING
        (uint _read,) = OSMedianizer(eth_price_oracle260).READ244();
        (uint _foresight,) = OSMedianizer(eth_price_oracle260).FORESIGHT875();
        p = _foresight < _read ? _foresight : _read;
    }

    function _CHECKDEBTCEILING877(uint _amt) internal view returns (bool) {	//inject NONSTANDARD NAMING
        (,,,uint _line,) = VatLike(vat).ILKS43(ilk992);
        uint _debt = GETTOTALDEBTAMOUNT152().ADD483(_amt);
        if (_line.DIV989(1e27) < _debt) { return false; }
        return true;
    }

    function _LOCKWETHANDDRAWDAI745(uint wad, uint wadD) internal {	//inject NONSTANDARD NAMING
        address urn = ManagerLike(cdp_manager).URNS226(cdpId);

                                                                            
        GemJoinLike(mcd_join_eth_a).JOIN168(urn, wad);
        ManagerLike(cdp_manager).FROB668(cdpId, TOINT917(wad), _GETDRAWDART399(urn, wadD));
        ManagerLike(cdp_manager).MOVE446(cdpId, address(this), wadD.MUL745(1e27));
        if (VatLike(vat).CAN946(address(this), address(mcd_join_dai)) == 0) {
            VatLike(vat).HOPE968(mcd_join_dai);
        }
        DaiJoinLike(mcd_join_dai).EXIT270(address(this), wadD);
    }

    function _GETDRAWDART399(address urn, uint wad) internal returns (int dart) {	//inject NONSTANDARD NAMING
        uint rate = JugLike(jug).DRIP111(ilk992);
        uint _dai = VatLike(vat).DAI231(urn);

        // If there was already enough DAI in the vat balance, just exits it without adding more debt
        if (_dai < wad.MUL745(1e27)) {
            dart = TOINT917(wad.MUL745(1e27).SUB518(_dai).DIV989(rate));
            dart = uint(dart).MUL745(rate) < wad.MUL745(1e27) ? dart + 1 : dart;
        }
    }

    function TOINT917(uint x) internal pure returns (int y) {	//inject NONSTANDARD NAMING
        y = int(x);
        require(y >= 0, "int-overflow");
    }

    // Controller only function for creating additional rewards from dust
    function WITHDRAW88(IERC20 _asset) external returns (uint balance) {	//inject NONSTANDARD NAMING
        require(msg.sender == controller, "!controller");
        require(want613 != address(_asset), "want");
        require(dai951 != address(_asset), "dai");
        balance = _asset.BALANCEOF367(address(this));
        _asset.SAFETRANSFER392(controller, balance);
    }

    // Withdraw partial funds, normally used with a vault withdrawal
    function WITHDRAW88(uint _amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == controller, "!controller");
        uint _balance = IERC20(want613).BALANCEOF367(address(this));
        if (_balance < _amount) {
            _amount = _WITHDRAWSOME510(_amount.SUB518(_balance));
            _amount = _amount.ADD483(_balance);
        }

        uint _fee = _amount.MUL745(withdrawalFee).DIV989(withdrawalmax723);

        IERC20(want613).SAFETRANSFER392(Controller(controller).REWARDS983(), _fee);
        address _vault = Controller(controller).VAULTS407(address(want613));
        require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds

        IERC20(want613).SAFETRANSFER392(_vault, _amount.SUB518(_fee));
    }
    
    function SHOULDREBALANCE692() external view returns (bool) {	//inject NONSTANDARD NAMING
        return GETMVAULTRATIO318() < c_safe.MUL745(1e2);
    }
    
    function REBALANCE223() external {	//inject NONSTANDARD NAMING
        uint safe = c_safe.MUL745(1e2);
        if (GETMVAULTRATIO318() < safe) {
            uint d = GETTOTALDEBTAMOUNT152();
            uint diff = safe.SUB518(GETMVAULTRATIO318());
            uint free = d.MUL745(diff).DIV989(safe);
            uint p = _GETPRICE756();
            _WIPE82(_WITHDRAWDAI331(free.MUL745(p).DIV989(1e18)));
        }
    }
    
    function FORCEREBALANCE268(uint _amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        uint p = _GETPRICE756();
        _WIPE82(_WITHDRAWDAI331(_amount.MUL745(p).DIV989(1e18)));
    }

    function _WITHDRAWSOME510(uint256 _amount) internal returns (uint) {	//inject NONSTANDARD NAMING
        uint p = _GETPRICE756();
        
        if (GETMVAULTRATIONEXT436(_amount) < c_safe.MUL745(1e2)) {
            _WIPE82(_WITHDRAWDAI331(_amount.MUL745(p).DIV989(1e18)));
        }
        
        // _amount in want
        _FREEWETH537(_amount);
        
        return _amount;
    }

    function _FREEWETH537(uint wad) internal {	//inject NONSTANDARD NAMING
        ManagerLike(cdp_manager).FROB668(cdpId, -TOINT917(wad), 0);
        ManagerLike(cdp_manager).FLUX641(cdpId, address(this), wad);
        GemJoinLike(mcd_join_eth_a).EXIT270(address(this), wad);
    }

    function _WIPE82(uint wad) internal {	//inject NONSTANDARD NAMING
        // wad in DAI
        address urn = ManagerLike(cdp_manager).URNS226(cdpId);

        DaiJoinLike(mcd_join_dai).JOIN168(urn, wad);
        ManagerLike(cdp_manager).FROB668(cdpId, 0, _GETWIPEDART74(VatLike(vat).DAI231(urn), urn));
    }

    function _GETWIPEDART74(	//inject NONSTANDARD NAMING
        uint _dai,
        address urn
    ) internal view returns (int dart) {
        (, uint rate,,,) = VatLike(vat).ILKS43(ilk992);
        (, uint art) = VatLike(vat).URNS226(ilk992, urn);

        dart = TOINT917(_dai / rate);
        dart = uint(dart) <= art ? - dart : - TOINT917(art);
    }

    // Withdraw all funds, normally used when migrating strategies
    function WITHDRAWALL107() external returns (uint balance) {	//inject NONSTANDARD NAMING
        require(msg.sender == controller, "!controller");
        _WITHDRAWALL392();

        _SWAP138(IERC20(dai951).BALANCEOF367(address(this)));
        balance = IERC20(want613).BALANCEOF367(address(this));

        address _vault = Controller(controller).VAULTS407(address(want613));
        require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
        IERC20(want613).SAFETRANSFER392(_vault, balance);
    }

    function _WITHDRAWALL392() internal {	//inject NONSTANDARD NAMING
        yVault(yvaultdai641).WITHDRAWALL107(); // get Dai
        _WIPE82(GETTOTALDEBTAMOUNT152().ADD483(1)); // in case of edge case
        _FREEWETH537(BALANCEOFMVAULT489());
    }

    function BALANCEOF367() public view returns (uint) {	//inject NONSTANDARD NAMING
        return BALANCEOFWANT874()
               .ADD483(BALANCEOFMVAULT489());
    }

    function BALANCEOFWANT874() public view returns (uint) {	//inject NONSTANDARD NAMING
        return IERC20(want613).BALANCEOF367(address(this));
    }

    function BALANCEOFMVAULT489() public view returns (uint) {	//inject NONSTANDARD NAMING
        uint ink;
        address urnHandler = ManagerLike(cdp_manager).URNS226(cdpId);
        (ink,) = VatLike(vat).URNS226(ilk992, urnHandler);
        return ink;
    }

    function HARVEST338() public {	//inject NONSTANDARD NAMING
        require(msg.sender == strategist || msg.sender == harvester || msg.sender == governance, "!authorized");
        
        uint v = GETUNDERLYINGDAI934(yVault(yvaultdai641).BALANCEOF367(address(this)));
        uint d = GETTOTALDEBTAMOUNT152();
        require(v > d, "profit is not realized yet!");
        uint profit = v.SUB518(d);

        _SWAP138(_WITHDRAWDAI331(profit));

        uint _want = IERC20(want613).BALANCEOF367(address(this));
        if (_want > 0) {
            uint _fee = _want.MUL745(performanceFee).DIV989(performancemax585);
            IERC20(want613).SAFETRANSFER392(strategist, _fee);
            _want = _want.SUB518(_fee);
        }

        DEPOSIT926();
    }

    function PAYBACK925(uint _amount) public {	//inject NONSTANDARD NAMING
        // _amount in Dai
        _WIPE82(_WITHDRAWDAI331(_amount));
    }

    function GETTOTALDEBTAMOUNT152() public view returns (uint) {	//inject NONSTANDARD NAMING
        uint art;
        uint rate;
        address urnHandler = ManagerLike(cdp_manager).URNS226(cdpId);
        (,art) = VatLike(vat).URNS226(ilk992, urnHandler);
        (,rate,,,) = VatLike(vat).ILKS43(ilk992);
        return art.MUL745(rate).DIV989(1e27);
    }
    
    function GETMVAULTRATIONEXT436(uint amount) public view returns (uint) {	//inject NONSTANDARD NAMING
        uint spot; // ray
        uint liquidationRatio; // ray
        uint denominator = GETTOTALDEBTAMOUNT152();
        (,,spot,,) = VatLike(vat).ILKS43(ilk992);
        (,liquidationRatio) = SpotLike(mcd_spot).ILKS43(ilk992);
        uint delayedCPrice = spot.MUL745(liquidationRatio).DIV989(1e27); // ray
        uint numerator = (BALANCEOFMVAULT489().SUB518(amount)).MUL745(delayedCPrice).DIV989(1e18); // ray
        return numerator.DIV989(denominator).DIV989(1e3);
    }

    function GETMVAULTRATIO318() public view returns (uint) {	//inject NONSTANDARD NAMING
        uint spot; // ray
        uint liquidationRatio; // ray
        uint denominator = GETTOTALDEBTAMOUNT152();
        (,,spot,,) = VatLike(vat).ILKS43(ilk992);
        (,liquidationRatio) = SpotLike(mcd_spot).ILKS43(ilk992);
        uint delayedCPrice = spot.MUL745(liquidationRatio).DIV989(1e27); // ray
        uint numerator = BALANCEOFMVAULT489().MUL745(delayedCPrice).DIV989(1e18); // ray
        return numerator.DIV989(denominator).DIV989(1e3);
    }

    function GETUNDERLYINGWITHDRAWALFEE628() public view returns (uint) {	//inject NONSTANDARD NAMING
        address _strategy = Controller(controller).STRATEGIES225(dai951);
        return Strategy(_strategy).WITHDRAWALFEE924();
    }

    function GETUNDERLYINGDAI934(uint _shares) public view returns (uint) {	//inject NONSTANDARD NAMING
        return (yVault(yvaultdai641).BALANCE390())
                .MUL745(_shares).DIV989(yVault(yvaultdai641).TOTALSUPPLY3())
                .MUL745(withdrawalmax723.SUB518(GETUNDERLYINGWITHDRAWALFEE628()))
                .DIV989(withdrawalmax723);
    }

    function _WITHDRAWDAI331(uint _amount) internal returns (uint) {	//inject NONSTANDARD NAMING
        uint _shares = _amount
                        .MUL745(yVault(yvaultdai641).TOTALSUPPLY3())
                        .DIV989(yVault(yvaultdai641).BALANCE390())
                        .MUL745(withdrawalmax723)
                        .DIV989(withdrawalmax723.SUB518(GETUNDERLYINGWITHDRAWALFEE628()));
        yVault(yvaultdai641).WITHDRAW88(_shares);
        return IERC20(dai951).BALANCEOF367(address(this));
    }

    function _SWAP138(uint _amountIn) internal {	//inject NONSTANDARD NAMING
        address[] memory path = new address[](2);
        path[0] = address(dai951);
        path[1] = address(want613);

                                         
        Uni(unirouter43).SWAPEXACTTOKENSFORTOKENS833(_amountIn, 0, path, address(this), now.ADD483(1 days));
    }

    function SETGOVERNANCE389(address _governance) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }

    function SETCONTROLLER804(address _controller) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        controller = _controller;
    }
}