                                                                 

// File: contracts/interfaces/IDelegable.sol

pragma solidity ^0.6.10;


interface IDelegable {
    function ADDDELEGATE653(address) external;	//inject NONSTANDARD NAMING
    function ADDDELEGATEBYSIGNATURE882(address, address, uint, uint8, bytes32, bytes32) external;	//inject NONSTANDARD NAMING
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


pragma solidity ^0.6.0;

                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY521() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF833(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER582(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE506(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE147(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM451(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER75(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL533(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// File: contracts/interfaces/IVat.sol

pragma solidity ^0.6.10;


                                                                  
                                                                                                                            
interface IVat {
    // function can(address, address) external view returns (uint);
    function HOPE952(address) external;	//inject NONSTANDARD NAMING
    function NOPE303(address) external;	//inject NONSTANDARD NAMING
    function LIVE610() external view returns (uint);	//inject NONSTANDARD NAMING
    function ILKS57(bytes32) external view returns (uint, uint, uint, uint, uint);	//inject NONSTANDARD NAMING
    function URNS490(bytes32, address) external view returns (uint, uint);	//inject NONSTANDARD NAMING
    function GEM988(bytes32, address) external view returns (uint);	//inject NONSTANDARD NAMING
    // function dai(address) external view returns (uint);
    function FROB42(bytes32, address, address, address, int, int) external;	//inject NONSTANDARD NAMING
    function FORK314(bytes32, address, address, int, int) external;	//inject NONSTANDARD NAMING
    function MOVE289(address, address, uint) external;	//inject NONSTANDARD NAMING
    function FLUX433(bytes32, address, address, uint) external;	//inject NONSTANDARD NAMING
}

// File: contracts/interfaces/IWeth.sol

pragma solidity ^0.6.10;


interface IWeth {
    function DEPOSIT338() external payable;	//inject NONSTANDARD NAMING
    function WITHDRAW817(uint) external;	//inject NONSTANDARD NAMING
    function APPROVE147(address, uint) external returns (bool) ;	//inject NONSTANDARD NAMING
    function TRANSFER582(address, uint) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM451(address, address, uint) external returns (bool);	//inject NONSTANDARD NAMING
}

// File: contracts/interfaces/IGemJoin.sol

pragma solidity ^0.6.10;


                                                                                     
interface IGemJoin {
    function RELY66(address usr) external;	//inject NONSTANDARD NAMING
    function DENY577(address usr) external;	//inject NONSTANDARD NAMING
    function CAGE307() external;	//inject NONSTANDARD NAMING
    function JOIN369(address usr, uint WAD) external;	//inject NONSTANDARD NAMING
    function EXIT932(address usr, uint WAD) external;	//inject NONSTANDARD NAMING
}

// File: contracts/interfaces/IDaiJoin.sol

pragma solidity ^0.6.10;


                                                                                   
interface IDaiJoin {
    function RELY66(address usr) external;	//inject NONSTANDARD NAMING
    function DENY577(address usr) external;	//inject NONSTANDARD NAMING
    function CAGE307() external;	//inject NONSTANDARD NAMING
    function JOIN369(address usr, uint WAD) external;	//inject NONSTANDARD NAMING
    function EXIT932(address usr, uint WAD) external;	//inject NONSTANDARD NAMING
}

// File: contracts/interfaces/IPot.sol

pragma solidity ^0.6.10;


                                                     
                                                                                                        
interface IPot {
    function CHI612() external view returns (uint256);	//inject NONSTANDARD NAMING
    function PIE445(address) external view returns (uint256); // Not a function, but a public variable.	//inject NONSTANDARD NAMING
    function RHO514() external returns (uint256);	//inject NONSTANDARD NAMING
    function DRIP65() external returns (uint256);	//inject NONSTANDARD NAMING
    function JOIN369(uint256) external;	//inject NONSTANDARD NAMING
    function EXIT932(uint256) external;	//inject NONSTANDARD NAMING
}

// File: contracts/interfaces/IChai.sol

pragma solidity ^0.6.10;


                                        
                                                                                                        
interface IChai {
    function BALANCEOF833(address account) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER582(address dst, uint wad) external returns (bool);	//inject NONSTANDARD NAMING
    function MOVE289(address src, address dst, uint wad) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM451(address src, address dst, uint wad) external returns (bool);	//inject NONSTANDARD NAMING
    function APPROVE147(address usr, uint wad) external returns (bool);	//inject NONSTANDARD NAMING
    function DAI858(address usr) external returns (uint wad);	//inject NONSTANDARD NAMING
    function JOIN369(address dst, uint wad) external;	//inject NONSTANDARD NAMING
    function EXIT932(address src, uint wad) external;	//inject NONSTANDARD NAMING
    function DRAW289(address src, uint wad) external;	//inject NONSTANDARD NAMING
    function PERMIT233(address holder, address spender, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s) external;	//inject NONSTANDARD NAMING
    function NONCES538(address account) external view returns (uint256);	//inject NONSTANDARD NAMING
}

// File: contracts/interfaces/ITreasury.sol

pragma solidity ^0.6.10;








interface ITreasury {
    function DEBT715() external view returns(uint256);	//inject NONSTANDARD NAMING
    function SAVINGS903() external view returns(uint256);	//inject NONSTANDARD NAMING
    function PUSHDAI613(address user, uint256 dai) external;	//inject NONSTANDARD NAMING
    function PULLDAI166(address user, uint256 dai) external;	//inject NONSTANDARD NAMING
    function PUSHCHAI91(address user, uint256 chai) external;	//inject NONSTANDARD NAMING
    function PULLCHAI479(address user, uint256 chai) external;	//inject NONSTANDARD NAMING
    function PUSHWETH634(address to, uint256 weth) external;	//inject NONSTANDARD NAMING
    function PULLWETH548(address to, uint256 weth) external;	//inject NONSTANDARD NAMING
    function SHUTDOWN178() external;	//inject NONSTANDARD NAMING
    function LIVE610() external view returns(bool);	//inject NONSTANDARD NAMING

    function VAT519() external view returns (IVat);	//inject NONSTANDARD NAMING
    function WETH278() external view returns (IWeth);	//inject NONSTANDARD NAMING
    function DAI858() external view returns (IERC20);	//inject NONSTANDARD NAMING
    function DAIJOIN173() external view returns (IDaiJoin);	//inject NONSTANDARD NAMING
    function WETHJOIN654() external view returns (IGemJoin);	//inject NONSTANDARD NAMING
    function POT408() external view returns (IPot);	//inject NONSTANDARD NAMING
    function CHAI326() external view returns (IChai);	//inject NONSTANDARD NAMING
}

// File: contracts/interfaces/IERC2612.sol

// Code adapted from https://github.com/OpenZeppelin/openzeppelin-contracts/pull/2237/
pragma solidity ^0.6.0;

                                                                                                                                                                                                                                                                                                                                                  
interface IERC2612 {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function PERMIT233(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                  
    function NONCES538(address owner) external view returns (uint256);	//inject NONSTANDARD NAMING
}

// File: contracts/interfaces/IFYDai.sol

pragma solidity ^0.6.10;



interface IFYDai is IERC20, IERC2612 {
    function ISMATURE431() external view returns(bool);	//inject NONSTANDARD NAMING
    function MATURITY388() external view returns(uint);	//inject NONSTANDARD NAMING
    function CHI0242() external view returns(uint);	//inject NONSTANDARD NAMING
    function RATE0398() external view returns(uint);	//inject NONSTANDARD NAMING
    function CHIGROWTH747() external view returns(uint);	//inject NONSTANDARD NAMING
    function RATEGROWTH408() external view returns(uint);	//inject NONSTANDARD NAMING
    function MATURE589() external;	//inject NONSTANDARD NAMING
    function UNLOCKED182() external view returns (uint);	//inject NONSTANDARD NAMING
    function MINT176(address, uint) external;	//inject NONSTANDARD NAMING
    function BURN250(address, uint) external;	//inject NONSTANDARD NAMING
    function FLASHMINT22(uint, bytes calldata) external;	//inject NONSTANDARD NAMING
    function REDEEM906(address, address, uint256) external returns (uint256);	//inject NONSTANDARD NAMING
    // function transfer(address, uint) external returns (bool);
    // function transferFrom(address, address, uint) external returns (bool);
    // function approve(address, uint) external returns (bool);
}

// File: contracts/interfaces/IController.sol

pragma solidity ^0.6.10;





interface IController is IDelegable {
    function TREASURY445() external view returns (ITreasury);	//inject NONSTANDARD NAMING
    function SERIES14(uint256) external view returns (IFYDai);	//inject NONSTANDARD NAMING
    function SERIESITERATOR268(uint256) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TOTALSERIES702() external view returns (uint256);	//inject NONSTANDARD NAMING
    function CONTAINSSERIES982(uint256) external view returns (bool);	//inject NONSTANDARD NAMING
    function POSTED950(bytes32, address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function DEBTFYDAI447(bytes32, uint256, address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function DEBTDAI877(bytes32, uint256, address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TOTALDEBTDAI51(bytes32, address) external view returns (uint256);	//inject NONSTANDARD NAMING
    function ISCOLLATERALIZED839(bytes32, address) external view returns (bool);	//inject NONSTANDARD NAMING
    function INDAI269(bytes32, uint256, uint256) external view returns (uint256);	//inject NONSTANDARD NAMING
    function INFYDAI474(bytes32, uint256, uint256) external view returns (uint256);	//inject NONSTANDARD NAMING
    function ERASE227(bytes32, address) external returns (uint256, uint256);	//inject NONSTANDARD NAMING
    function SHUTDOWN178() external;	//inject NONSTANDARD NAMING
    function POST95(bytes32, address, address, uint256) external;	//inject NONSTANDARD NAMING
    function WITHDRAW817(bytes32, address, address, uint256) external;	//inject NONSTANDARD NAMING
    function BORROW691(bytes32, uint256, address, address, uint256) external;	//inject NONSTANDARD NAMING
    function REPAYFYDAI426(bytes32, uint256, address, address, uint256) external returns (uint256);	//inject NONSTANDARD NAMING
    function REPAYDAI460(bytes32, uint256, address, address, uint256) external returns (uint256);	//inject NONSTANDARD NAMING
}

// File: contracts/interfaces/IDai.sol

pragma solidity ^0.6.10;


interface IDai is IERC20 {
    function NONCES538(address user) external view returns (uint256);	//inject NONSTANDARD NAMING
    function PERMIT233(address holder, address spender, uint256 nonce, uint256 expiry,	//inject NONSTANDARD NAMING
                    bool allowed, uint8 v, bytes32 r, bytes32 s) external;
}

// File: contracts/interfaces/IPool.sol

pragma solidity ^0.6.10;





interface IPool is IDelegable, IERC20, IERC2612 {
    function DAI858() external view returns(IERC20);	//inject NONSTANDARD NAMING
    function FYDAI600() external view returns(IFYDai);	//inject NONSTANDARD NAMING
    function GETDAIRESERVES173() external view returns(uint128);	//inject NONSTANDARD NAMING
    function GETFYDAIRESERVES833() external view returns(uint128);	//inject NONSTANDARD NAMING
    function SELLDAI400(address from, address to, uint128 daiIn) external returns(uint128);	//inject NONSTANDARD NAMING
    function BUYDAI253(address from, address to, uint128 daiOut) external returns(uint128);	//inject NONSTANDARD NAMING
    function SELLFYDAI226(address from, address to, uint128 fyDaiIn) external returns(uint128);	//inject NONSTANDARD NAMING
    function BUYFYDAI675(address from, address to, uint128 fyDaiOut) external returns(uint128);	//inject NONSTANDARD NAMING
    function SELLDAIPREVIEW300(uint128 daiIn) external view returns(uint128);	//inject NONSTANDARD NAMING
    function BUYDAIPREVIEW913(uint128 daiOut) external view returns(uint128);	//inject NONSTANDARD NAMING
    function SELLFYDAIPREVIEW69(uint128 fyDaiIn) external view returns(uint128);	//inject NONSTANDARD NAMING
    function BUYFYDAIPREVIEW685(uint128 fyDaiOut) external view returns(uint128);	//inject NONSTANDARD NAMING
    function MINT176(address from, address to, uint256 daiOffered) external returns (uint256);	//inject NONSTANDARD NAMING
    function BURN250(address from, address to, uint256 tokensBurned) external returns (uint256, uint256);	//inject NONSTANDARD NAMING
}

// File: @openzeppelin/contracts/math/SafeMath.sol


pragma solidity ^0.6.0;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                                    
    function ADD958(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB494(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB494(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB494(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL434(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV16(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV16(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV16(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD331(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD331(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD331(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/helpers/DecimalMath.sol

pragma solidity ^0.6.10;



                                                                                   
contract DecimalMath {
    using SafeMath for uint256;

    uint256 constant public unit17 = 1e27;	//inject NONSTANDARD NAMING

                                                                                   
    function MULD379(uint256 x, uint256 y) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return x.MUL434(y).DIV16(unit17);
    }

                                                                                    
    function DIVD836(uint256 x, uint256 y) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return x.MUL434(unit17).DIV16(y);
    }

                                                                                 
                                                                    
    function MULDRUP300(uint256 x, uint256 y) internal pure returns (uint256)	//inject NONSTANDARD NAMING
    {
        uint256 z = x.MUL434(y);
        return z.MOD331(unit17) == 0 ? z.DIV16(unit17) : z.DIV16(unit17).ADD958(1);
    }

                                                                                  
                                                                    
    function DIVDRUP370(uint256 x, uint256 y) internal pure returns (uint256)	//inject NONSTANDARD NAMING
    {
        uint256 z = x.MUL434(unit17);
        return z.MOD331(y) == 0 ? z.DIV16(y) : z.DIV16(y).ADD958(1);
    }
}

// File: contracts/peripheral/YieldProxy.sol

pragma solidity ^0.6.10;













library SafeCast {
                                                 
    function TOUINT128897(uint256 x) internal pure returns(uint128) {	//inject NONSTANDARD NAMING
        require(
            x <= type(uint128).max,
            "YieldProxy: Cast overflow"
        );
        return uint128(x);
    }

                                                
    function TOINT256710(uint256 x) internal pure returns(int256) {	//inject NONSTANDARD NAMING
        require(
            x <= uint256(type(int256).max),
            "YieldProxy: Cast overflow"
        );
        return int256(x);
    }
}

contract YieldProxy is DecimalMath {
    using SafeCast for uint256;

    IVat public vat;
    IWeth public weth;
    IDai public dai;
    IGemJoin public wethJoin;
    IDaiJoin public daiJoin;
    IChai public chai;
    IController public controller;
    ITreasury public treasury;

    IPool[] public pools;
    mapping (address => bool) public poolsMap;

    bytes32 public constant chai69 = "CHAI";	//inject NONSTANDARD NAMING
    bytes32 public constant weth148 = "ETH-A";	//inject NONSTANDARD NAMING
    bool constant public mty307 = true;	//inject NONSTANDARD NAMING
    bool constant public ytm282 = false;	//inject NONSTANDARD NAMING


    constructor(address controller_, IPool[] memory _pools) public {
        controller = IController(controller_);
        treasury = controller.TREASURY445();

        weth = treasury.WETH278();
        dai = IDai(address(treasury.DAI858()));
        chai = treasury.CHAI326();
        daiJoin = treasury.DAIJOIN173();
        wethJoin = treasury.WETHJOIN654();
        vat = treasury.VAT519();

        // for repaying debt
        dai.APPROVE147(address(treasury), uint(-1));

        // for posting to the controller
        chai.APPROVE147(address(treasury), uint(-1));
        weth.APPROVE147(address(treasury), uint(-1));

        // for converting DAI to CHAI
        dai.APPROVE147(address(chai), uint(-1));

        vat.HOPE952(address(daiJoin));
        vat.HOPE952(address(wethJoin));

        dai.APPROVE147(address(daiJoin), uint(-1));
        weth.APPROVE147(address(wethJoin), uint(-1));
        weth.APPROVE147(address(treasury), uint(-1));

        // allow all the pools to pull FYDai/dai from us for LPing
        for (uint i = 0 ; i < _pools.length; i++) {
            dai.APPROVE147(address(_pools[i]), uint(-1));
            _pools[i].FYDAI600().APPROVE147(address(_pools[i]), uint(-1));
            poolsMap[address(_pools[i])]= true;
        }

        pools = _pools;
    }

                                                       
    function UNPACK384(bytes memory signature) private pure returns (bytes32 r, bytes32 s, uint8 v) {	//inject NONSTANDARD NAMING
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }
    }

                                                                                                                                                       
    function ONBOARD51(address from, bytes memory daiSignature, bytes memory controllerSig) external {	//inject NONSTANDARD NAMING
        bytes32 r;
        bytes32 s;
        uint8 v;

        (r, s, v) = UNPACK384(daiSignature);
        dai.PERMIT233(from, address(this), dai.NONCES538(from), uint(-1), true, v, r, s);

        (r, s, v) = UNPACK384(controllerSig);
        controller.ADDDELEGATEBYSIGNATURE882(from, address(this), uint(-1), v, r, s);
    }

                                                                                                               
    function AUTHORIZEPOOL621(IPool pool, address from, bytes memory daiSig, bytes memory fyDaiSig, bytes memory poolSig) public {	//inject NONSTANDARD NAMING
        ONLYKNOWNPOOL167(pool);
        bytes32 r;
        bytes32 s;
        uint8 v;

        (r, s, v) = UNPACK384(daiSig);
        dai.PERMIT233(from, address(pool), dai.NONCES538(from), uint(-1), true, v, r, s);

        (r, s, v) = UNPACK384(fyDaiSig);
        pool.FYDAI600().PERMIT233(from, address(this), uint(-1), uint(-1), v, r, s);

        (r, s, v) = UNPACK384(poolSig);
        pool.ADDDELEGATEBYSIGNATURE882(from, address(this), uint(-1), v, r, s);
    }

                                                                                                     
    receive() external payable { }

                                                                                                                                     
                                                       
    function POST95(address to)	//inject NONSTANDARD NAMING
        public payable {
        weth.DEPOSIT338{ value: msg.value }();
        controller.POST95(weth148, address(this), to, msg.value);
    }

                                                                                                      
                                                                                                                           
                                        
                                             
    function WITHDRAW817(address payable to, uint256 amount)	//inject NONSTANDARD NAMING
        public {
        controller.WITHDRAW817(weth148, msg.sender, address(this), amount);
        weth.WITHDRAW817(amount);
        to.transfer(amount);
    }

                                                                                       
                                                                                     
                                                                              
                                                               
                                                                                  
                                                        
    function ADDLIQUIDITY157(IPool pool, uint256 daiUsed, uint256 maxFYDai) external returns (uint256) {	//inject NONSTANDARD NAMING
        ONLYKNOWNPOOL167(pool);
        IFYDai fyDai = pool.FYDAI600();
        require(fyDai.ISMATURE431() != true, "YieldProxy: Only before maturity");
        require(dai.TRANSFERFROM451(msg.sender, address(this), daiUsed), "YieldProxy: Transfer Failed");

        // calculate needed fyDai
        uint256 daiReserves = dai.BALANCEOF833(address(pool));
        uint256 fyDaiReserves = fyDai.BALANCEOF833(address(pool));
        uint256 daiToAdd = daiUsed.MUL434(daiReserves).DIV16(fyDaiReserves.ADD958(daiReserves));
        uint256 daiToConvert = daiUsed.SUB494(daiToAdd);
        require(
            daiToConvert <= maxFYDai,
            "YieldProxy: maxFYDai exceeded"
        ); // 1 Dai == 1 fyDai

        // convert dai to chai and borrow needed fyDai
        chai.JOIN369(address(this), daiToConvert);
        // look at the balance of chai in dai to avoid rounding issues
        uint256 toBorrow = chai.DAI858(address(this));
        controller.POST95(chai69, address(this), msg.sender, chai.BALANCEOF833(address(this)));
        controller.BORROW691(chai69, fyDai.MATURITY388(), msg.sender, address(this), toBorrow);
        
        // mint liquidity tokens
        return pool.MINT176(address(this), msg.sender, daiToAdd);
    }

                                                                                                                                                                                                                            
                                                                                                                        
                                                                                    
                                                         
                                                                                                  
                                                                                                      
    function REMOVELIQUIDITYEARLYDAIPOOL932(IPool pool, uint256 poolTokens, uint256 minimumDaiPrice, uint256 minimumFYDaiPrice) external {	//inject NONSTANDARD NAMING
        ONLYKNOWNPOOL167(pool);
        IFYDai fyDai = pool.FYDAI600();
        uint256 maturity = fyDai.MATURITY388();
        (uint256 daiObtained, uint256 fyDaiObtained) = pool.BURN250(msg.sender, address(this), poolTokens);

        // Exchange Dai for fyDai to pay as much debt as possible
        uint256 fyDaiBought = pool.SELLDAI400(address(this), address(this), daiObtained.TOUINT128897());
        require(
            fyDaiBought >= MULD379(daiObtained, minimumDaiPrice),
            "YieldProxy: minimumDaiPrice not reached"
        );
        fyDaiObtained = fyDaiObtained.ADD958(fyDaiBought);
        
        uint256 fyDaiUsed;
        if (fyDaiObtained > 0 && controller.DEBTFYDAI447(chai69, maturity, msg.sender) > 0) {
            fyDaiUsed = controller.REPAYFYDAI426(chai69, maturity, address(this), msg.sender, fyDaiObtained);
        }
        uint256 fyDaiRemaining = fyDaiObtained.SUB494(fyDaiUsed);

        if (fyDaiRemaining > 0) {// There is fyDai left, so exchange it for Dai to withdraw only Dai and Chai
            require(
                pool.SELLFYDAI226(address(this), address(this), uint128(fyDaiRemaining)) >= MULD379(fyDaiRemaining, minimumFYDaiPrice),
                "YieldProxy: minimumFYDaiPrice not reached"
            );
        }
        WITHDRAWASSETS926(fyDai);
    }

                                                                                                                                                                             
                                                                                                                        
                                                                                    
                                                         
                                                                                                      
    function REMOVELIQUIDITYEARLYDAIFIXED8(IPool pool, uint256 poolTokens, uint256 minimumFYDaiPrice) external {	//inject NONSTANDARD NAMING
        ONLYKNOWNPOOL167(pool);
        IFYDai fyDai = pool.FYDAI600();
        uint256 maturity = fyDai.MATURITY388();
        (uint256 daiObtained, uint256 fyDaiObtained) = pool.BURN250(msg.sender, address(this), poolTokens);

        uint256 fyDaiUsed;
        if (fyDaiObtained > 0 && controller.DEBTFYDAI447(chai69, maturity, msg.sender) > 0) {
            fyDaiUsed = controller.REPAYFYDAI426(chai69, maturity, address(this), msg.sender, fyDaiObtained);
        }

        uint256 fyDaiRemaining = fyDaiObtained.SUB494(fyDaiUsed);
        if (fyDaiRemaining == 0) { // We used all the fyDai, so probably there is debt left, so pay with Dai
            if (daiObtained > 0 && controller.DEBTFYDAI447(chai69, maturity, msg.sender) > 0) {
                controller.REPAYDAI460(chai69, maturity, address(this), msg.sender, daiObtained);
            }
        } else { // Exchange remaining fyDai for Dai to withdraw only Dai and Chai
            require(
                pool.SELLFYDAI226(address(this), address(this), uint128(fyDaiRemaining)) >= MULD379(fyDaiRemaining, minimumFYDaiPrice),
                "YieldProxy: minimumFYDaiPrice not reached"
            );
        }
        WITHDRAWASSETS926(fyDai);
    }

                                                                
                                                                                     
                                                                                    
                                                        
    function REMOVELIQUIDITYMATURE267(IPool pool, uint256 poolTokens) external {	//inject NONSTANDARD NAMING
        ONLYKNOWNPOOL167(pool);
        IFYDai fyDai = pool.FYDAI600();
        uint256 maturity = fyDai.MATURITY388();
        (uint256 daiObtained, uint256 fyDaiObtained) = pool.BURN250(msg.sender, address(this), poolTokens);
        if (fyDaiObtained > 0) {
            daiObtained = daiObtained.ADD958(fyDai.REDEEM906(address(this), address(this), fyDaiObtained));
        }
        
        // Repay debt
        if (daiObtained > 0 && controller.DEBTFYDAI447(chai69, maturity, msg.sender) > 0) {
            controller.REPAYDAI460(chai69, maturity, address(this), msg.sender, daiObtained);
        }
        WITHDRAWASSETS926(fyDai);
    }

                                                                                                                            
    function WITHDRAWASSETS926(IFYDai fyDai) internal {	//inject NONSTANDARD NAMING
        if (controller.DEBTFYDAI447(chai69, fyDai.MATURITY388(), msg.sender) == 0) {
            controller.WITHDRAW817(chai69, msg.sender, address(this), controller.POSTED950(chai69, msg.sender));
            chai.EXIT932(address(this), chai.BALANCEOF833(address(this)));
        }
        require(dai.TRANSFER582(msg.sender, dai.BALANCEOF833(address(this))), "YieldProxy: Dai Transfer Failed");
    }

                                                                                                    
                                                                                          
                                                
                                                   
                                                      
                                                              
                                                                       
    function BORROWDAIFORMAXIMUMFYDAI736(	//inject NONSTANDARD NAMING
        IPool pool,
        bytes32 collateral,
        uint256 maturity,
        address to,
        uint256 maximumFYDai,
        uint256 daiToBorrow
    )
        public
        returns (uint256)
    {
        ONLYKNOWNPOOL167(pool);
        uint256 fyDaiToBorrow = pool.BUYDAIPREVIEW913(daiToBorrow.TOUINT128897());
        require (fyDaiToBorrow <= maximumFYDai, "YieldProxy: Too much fyDai required");

        // The collateral for this borrow needs to have been posted beforehand
        controller.BORROW691(collateral, maturity, msg.sender, address(this), fyDaiToBorrow);
        pool.BUYDAI253(address(this), to, daiToBorrow.TOUINT128897());

        return fyDaiToBorrow;
    }

                                                                                                                           
                                                                                          
                                                
                                                   
                                                      
                                                       
                                                                                
    function BORROWMINIMUMDAIFORFYDAI776(	//inject NONSTANDARD NAMING
        IPool pool,
        bytes32 collateral,
        uint256 maturity,
        address to,
        uint256 fyDaiToBorrow,
        uint256 minimumDaiToBorrow
    )
        public
        returns (uint256)
    {
        ONLYKNOWNPOOL167(pool);
        // The collateral for this borrow needs to have been posted beforehand
        controller.BORROW691(collateral, maturity, msg.sender, address(this), fyDaiToBorrow);
        uint256 boughtDai = pool.SELLFYDAI226(address(this), to, fyDaiToBorrow.TOUINT128897());
        require (boughtDai >= minimumDaiToBorrow, "YieldProxy: Not enough Dai obtained");

        return boughtDai;
    }

                                                                                                                                          
                                                                                    
                                                                                             
                                                
                                                   
                                                      
                                                            
                                                                                                 
    function REPAYFYDAIDEBTFORMAXIMUMDAI955(	//inject NONSTANDARD NAMING
        IPool pool,
        bytes32 collateral,
        uint256 maturity,
        address to,
        uint256 fyDaiRepayment,
        uint256 maximumRepaymentInDai
    )
        public
        returns (uint256)
    {
        ONLYKNOWNPOOL167(pool);
        uint256 fyDaiDebt = controller.DEBTFYDAI447(collateral, maturity, to);
        uint256 fyDaiToUse = fyDaiDebt < fyDaiRepayment ? fyDaiDebt : fyDaiRepayment; // Use no more fyDai than debt
        uint256 repaymentInDai = pool.BUYFYDAI675(msg.sender, address(this), fyDaiToUse.TOUINT128897());
        require (repaymentInDai <= maximumRepaymentInDai, "YieldProxy: Too much Dai required");
        controller.REPAYFYDAI426(collateral, maturity, address(this), to, fyDaiToUse);

        return repaymentInDai;
    }

                                                                                                                                                                         
                                                                                    
                                                                                           
                                                
                                                   
                                                      
                                                                           
                                                                                        
    function REPAYMINIMUMFYDAIDEBTFORDAI862(	//inject NONSTANDARD NAMING
        IPool pool,
        bytes32 collateral,
        uint256 maturity,
        address to,
        uint256 minimumFYDaiRepayment,
        uint256 repaymentInDai
    )
        public
        returns (uint256)
    {
        ONLYKNOWNPOOL167(pool);
        uint256 fyDaiRepayment = pool.SELLDAIPREVIEW300(repaymentInDai.TOUINT128897());
        uint256 fyDaiDebt = controller.DEBTFYDAI447(collateral, maturity, to);
        if(fyDaiRepayment <= fyDaiDebt) { // Sell no more Dai than needed to cancel all the debt
            pool.SELLDAI400(msg.sender, address(this), repaymentInDai.TOUINT128897());
        } else { // If we have too much Dai, then don't sell it all and buy the exact amount of fyDai needed instead.
            pool.BUYFYDAI675(msg.sender, address(this), fyDaiDebt.TOUINT128897());
            fyDaiRepayment = fyDaiDebt;
        }
        require (fyDaiRepayment >= minimumFYDaiRepayment, "YieldProxy: Not enough fyDai debt repaid");
        controller.REPAYFYDAI426(collateral, maturity, address(this), to, fyDaiRepayment);

        return fyDaiRepayment;
    }

                               
                                                         
                                             
                                                               
    function SELLDAI400(IPool pool, address to, uint128 daiIn, uint128 minFYDaiOut)	//inject NONSTANDARD NAMING
        external
        returns(uint256)
    {
        ONLYKNOWNPOOL167(pool);
        uint256 fyDaiOut = pool.SELLDAI400(msg.sender, to, daiIn);
        require(
            fyDaiOut >= minFYDaiOut,
            "YieldProxy: Limit not reached"
        );
        return fyDaiOut;
    }

                              
                                                       
                                                
                                                            
    function BUYDAI253(IPool pool, address to, uint128 daiOut, uint128 maxFYDaiIn)	//inject NONSTANDARD NAMING
        public
        returns(uint256)
    {
        ONLYKNOWNPOOL167(pool);
        uint256 fyDaiIn = pool.BUYDAI253(msg.sender, to, daiOut);
        require(
            maxFYDaiIn >= fyDaiIn,
            "YieldProxy: Limit exceeded"
        );
        return fyDaiIn;
    }

                                                                     
                                                       
                                                
                                                            
                                                      
    function BUYDAIWITHSIGNATURE110(IPool pool, address to, uint128 daiOut, uint128 maxFYDaiIn, bytes memory signature)	//inject NONSTANDARD NAMING
        external
        returns(uint256)
    {
        ONLYKNOWNPOOL167(pool);
        (bytes32 r, bytes32 s, uint8 v) = UNPACK384(signature);
        pool.FYDAI600().PERMIT233(msg.sender, address(pool), uint(-1), uint(-1), v, r, s);

        return BUYDAI253(pool, to, daiOut, maxFYDaiIn);
    }

                               
                                                       
                                                 
                                                           
    function SELLFYDAI226(IPool pool, address to, uint128 fyDaiIn, uint128 minDaiOut)	//inject NONSTANDARD NAMING
        public
        returns(uint256)
    {
        ONLYKNOWNPOOL167(pool);
        uint256 daiOut = pool.SELLFYDAI226(msg.sender, to, fyDaiIn);
        require(
            daiOut >= minDaiOut,
            "YieldProxy: Limit not reached"
        );
        return daiOut;
    }

                                                                    
                                                       
                                                 
                                                           
                                                      
    function SELLFYDAIWITHSIGNATURE545(IPool pool, address to, uint128 fyDaiIn, uint128 minDaiOut, bytes memory signature)	//inject NONSTANDARD NAMING
        external
        returns(uint256)
    {
        ONLYKNOWNPOOL167(pool);
        (bytes32 r, bytes32 s, uint8 v) = UNPACK384(signature);
        pool.FYDAI600().PERMIT233(msg.sender, address(pool), uint(-1), uint(-1), v, r, s);

        return SELLFYDAI226(pool, to, fyDaiIn, minDaiOut);
    }

                              
                                                         
                                                    
                                                        
    function BUYFYDAI675(IPool pool, address to, uint128 fyDaiOut, uint128 maxDaiIn)	//inject NONSTANDARD NAMING
        external
        returns(uint256)
    {
        ONLYKNOWNPOOL167(pool);
        uint256 daiIn = pool.BUYFYDAI675(msg.sender, to, fyDaiOut);
        require(
            maxDaiIn >= daiIn,
            "YieldProxy: Limit exceeded"
        );
        return daiIn;
    }

                                                                  
                                                                                              
                                                                                                                               
                                                                                                                    
                                                
                                                   
                                                
                                                                 
                                                      
    function REPAYDAIWITHSIGNATURE818(bytes32 collateral, uint256 maturity, address to, uint256 daiAmount, bytes memory signature)	//inject NONSTANDARD NAMING
        external
        returns(uint256)
    {
        (bytes32 r, bytes32 s, uint8 v) = UNPACK384(signature);
        dai.PERMIT233(msg.sender, address(treasury), dai.NONCES538(msg.sender), uint(-1), true, v, r, s);
        controller.REPAYDAI460(collateral, maturity, msg.sender, to, daiAmount);
    }

    function ONLYKNOWNPOOL167(IPool pool) private view {	//inject NONSTANDARD NAMING
        require(poolsMap[address(pool)], "YieldProxy: Unknown pool");
    }
}