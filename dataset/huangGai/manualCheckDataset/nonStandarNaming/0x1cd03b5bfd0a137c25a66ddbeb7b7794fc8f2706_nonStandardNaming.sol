                                                                 

pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;

interface iuniswap2 {	//inject NONSTANDARD NAMING
  // To convert DAI to ETH
  function SWAPEXACTTOKENSFORETH53(uint AMOUNTIN88, uint AMOUNTOUTMIN99, address[] calldata PATH78, address TO76, uint DEADLINE33) external returns (uint[] memory AMOUNTS56);	//inject NONSTANDARD NAMING
  // To convert ETH to YELD and burn it
  function SWAPEXACTETHFORTOKENS6(uint AMOUNTOUTMIN99, address[] calldata PATH78, address TO76, uint DEADLINE33) external payable returns (uint[] memory AMOUNTS56);	//inject NONSTANDARD NAMING
}

interface ierc2093 {	//inject NONSTANDARD NAMING
    function TOTALSUPPLY70() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF25(address ACCOUNT45) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER37(address RECIPIENT39, uint256 AMOUNT4) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE65(address OWNER26, address SPENDER52) external view returns (uint256);	//inject NONSTANDARD NAMING
    function APPROVE3(address SPENDER52, uint256 AMOUNT4) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM19(address SENDER75, address RECIPIENT39, uint256 AMOUNT4) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER22(address indexed FROM88, address indexed TO76, uint256 VALUE83);	//inject NONSTANDARD NAMING
    event APPROVAL93(address indexed OWNER26, address indexed SPENDER52, uint256 VALUE83);	//inject NONSTANDARD NAMING
}

contract context61 {	//inject NONSTANDARD NAMING
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER82() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA79() internal view returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract ownable93 is context61 {	//inject NONSTANDARD NAMING
    address payable private _OWNER43;	//inject NONSTANDARD NAMING

    event OWNERSHIPTRANSFERRED63(address indexed PREVIOUSOWNER24, address indexed NEWOWNER52);	//inject NONSTANDARD NAMING
    constructor () internal {
        _OWNER43 = _MSGSENDER82();
        emit OWNERSHIPTRANSFERRED63(address(0), _OWNER43);
    }
    function OWNER99() public view returns (address payable) {	//inject NONSTANDARD NAMING
        return _OWNER43;
    }
    modifier ONLYOWNER61() {	//inject NONSTANDARD NAMING
        require(ISOWNER2(), "Ownable: caller is not the owner");
        _;
    }
    function ISOWNER2() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _MSGSENDER82() == _OWNER43;
    }
    function RENOUNCEOWNERSHIP13() public ONLYOWNER61 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED63(_OWNER43, address(0));
        _OWNER43 = address(0);
    }
    function TRANSFEROWNERSHIP7(address payable NEWOWNER52) public ONLYOWNER61 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP60(NEWOWNER52);
    }
    function _TRANSFEROWNERSHIP60(address payable NEWOWNER52) internal {	//inject NONSTANDARD NAMING
        require(NEWOWNER52 != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED63(_OWNER43, NEWOWNER52);
        _OWNER43 = NEWOWNER52;
    }
}

contract erc2030 is context61, ierc2093 {	//inject NONSTANDARD NAMING
    using safemath13 for uint256;

    mapping (address => uint256) _BALANCES15;	//inject NONSTANDARD NAMING

    mapping (address => mapping (address => uint256)) private _ALLOWANCES69;	//inject NONSTANDARD NAMING

    uint256 _TOTALSUPPLY32;	//inject NONSTANDARD NAMING
    function TOTALSUPPLY70() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _TOTALSUPPLY32;
    }
    function BALANCEOF25(address ACCOUNT45) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _BALANCES15[ACCOUNT45];
    }
    function TRANSFER37(address RECIPIENT39, uint256 AMOUNT4) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER95(_MSGSENDER82(), RECIPIENT39, AMOUNT4);
        return true;
    }
    function ALLOWANCE65(address OWNER26, address SPENDER52) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _ALLOWANCES69[OWNER26][SPENDER52];
    }
    function APPROVE3(address SPENDER52, uint256 AMOUNT4) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE30(_MSGSENDER82(), SPENDER52, AMOUNT4);
        return true;
    }
    function TRANSFERFROM19(address SENDER75, address RECIPIENT39, uint256 AMOUNT4) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER95(SENDER75, RECIPIENT39, AMOUNT4);
        _APPROVE30(SENDER75, _MSGSENDER82(), _ALLOWANCES69[SENDER75][_MSGSENDER82()].SUB57(AMOUNT4, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function INCREASEALLOWANCE47(address SPENDER52, uint256 ADDEDVALUE76) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE30(_MSGSENDER82(), SPENDER52, _ALLOWANCES69[_MSGSENDER82()][SPENDER52].ADD27(ADDEDVALUE76));
        return true;
    }
    function DECREASEALLOWANCE20(address SPENDER52, uint256 SUBTRACTEDVALUE75) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE30(_MSGSENDER82(), SPENDER52, _ALLOWANCES69[_MSGSENDER82()][SPENDER52].SUB57(SUBTRACTEDVALUE75, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _TRANSFER95(address SENDER75, address RECIPIENT39, uint256 AMOUNT4) internal {	//inject NONSTANDARD NAMING
        require(SENDER75 != address(0), "ERC20: transfer from the zero address");
        require(RECIPIENT39 != address(0), "ERC20: transfer to the zero address");

        _BALANCES15[SENDER75] = _BALANCES15[SENDER75].SUB57(AMOUNT4, "ERC20: transfer amount exceeds balance");
        _BALANCES15[RECIPIENT39] = _BALANCES15[RECIPIENT39].ADD27(AMOUNT4);
        emit TRANSFER22(SENDER75, RECIPIENT39, AMOUNT4);
    }
    function _MINT79(address ACCOUNT45, uint256 AMOUNT4) internal {	//inject NONSTANDARD NAMING
        require(ACCOUNT45 != address(0), "ERC20: mint to the zero address");

        _TOTALSUPPLY32 = _TOTALSUPPLY32.ADD27(AMOUNT4);
        _BALANCES15[ACCOUNT45] = _BALANCES15[ACCOUNT45].ADD27(AMOUNT4);
        emit TRANSFER22(address(0), ACCOUNT45, AMOUNT4);
    }
    function _BURN68(address ACCOUNT45, uint256 AMOUNT4) internal {	//inject NONSTANDARD NAMING
        require(ACCOUNT45 != address(0), "ERC20: burn from the zero address");

        _BALANCES15[ACCOUNT45] = _BALANCES15[ACCOUNT45].SUB57(AMOUNT4, "ERC20: burn amount exceeds balance");
        _TOTALSUPPLY32 = _TOTALSUPPLY32.SUB57(AMOUNT4);
        emit TRANSFER22(ACCOUNT45, address(0), AMOUNT4);
    }
    function _APPROVE30(address OWNER26, address SPENDER52, uint256 AMOUNT4) internal {	//inject NONSTANDARD NAMING
        require(OWNER26 != address(0), "ERC20: approve from the zero address");
        require(SPENDER52 != address(0), "ERC20: approve to the zero address");

        _ALLOWANCES69[OWNER26][SPENDER52] = AMOUNT4;
        emit APPROVAL93(OWNER26, SPENDER52, AMOUNT4);
    }
    function _BURNFROM66(address ACCOUNT45, uint256 AMOUNT4) internal {	//inject NONSTANDARD NAMING
        _BURN68(ACCOUNT45, AMOUNT4);
        _APPROVE30(ACCOUNT45, _MSGSENDER82(), _ALLOWANCES69[ACCOUNT45][_MSGSENDER82()].SUB57(AMOUNT4, "ERC20: burn amount exceeds allowance"));
    }
}

contract erc20detailed21 is ierc2093 {	//inject NONSTANDARD NAMING
    string private _NAME42;	//inject NONSTANDARD NAMING
    string private _SYMBOL85;	//inject NONSTANDARD NAMING
    uint8 private _DECIMALS78;	//inject NONSTANDARD NAMING

    constructor (string memory NAME99, string memory SYMBOL38, uint8 DECIMALS96) public {	//inject NONSTANDARD NAMING
        _NAME42 = NAME99;
        _SYMBOL85 = SYMBOL38;
        _DECIMALS78 = DECIMALS96;
    }
    function NAME45() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _NAME42;
    }
    function SYMBOL75() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _SYMBOL85;
    }
    function DECIMALS63() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _DECIMALS78;
    }
}

contract reentrancyguard94 {	//inject NONSTANDARD NAMING
    uint256 private _GUARDCOUNTER38;	//inject NONSTANDARD NAMING

    constructor () internal {
        _GUARDCOUNTER38 = 1;
    }

    modifier NONREENTRANT47() {	//inject NONSTANDARD NAMING
        _GUARDCOUNTER38 += 1;
        uint256 LOCALCOUNTER54 = _GUARDCOUNTER38;	//inject NONSTANDARD NAMING
        _;
        require(LOCALCOUNTER54 == _GUARDCOUNTER38, "ReentrancyGuard: reentrant call");
    }
}

library safemath13 {	//inject NONSTANDARD NAMING
    function ADD27(uint256 A32, uint256 B30) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 C51 = A32 + B30;	//inject NONSTANDARD NAMING
        require(C51 >= A32, "SafeMath: addition overflow");

        return C51;
    }
    function SUB57(uint256 A32, uint256 B30) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB57(A32, B30, "SafeMath: subtraction overflow");
    }
    function SUB57(uint256 A32, uint256 B30, string memory ERRORMESSAGE15) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(B30 <= A32, ERRORMESSAGE15);
        uint256 C51 = A32 - B30;	//inject NONSTANDARD NAMING

        return C51;
    }
    function MUL24(uint256 A32, uint256 B30) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (A32 == 0) {
            return 0;
        }

        uint256 C51 = A32 * B30;	//inject NONSTANDARD NAMING
        require(C51 / A32 == B30, "SafeMath: multiplication overflow");

        return C51;
    }
    function DIV26(uint256 A32, uint256 B30) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV26(A32, B30, "SafeMath: division by zero");
    }
    function DIV26(uint256 A32, uint256 B30, string memory ERRORMESSAGE15) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(B30 > 0, ERRORMESSAGE15);
        uint256 C51 = A32 / B30;	//inject NONSTANDARD NAMING

        return C51;
    }
    function MOD76(uint256 A32, uint256 B30) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD76(A32, B30, "SafeMath: modulo by zero");
    }
    function MOD76(uint256 A32, uint256 B30, string memory ERRORMESSAGE15) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(B30 != 0, ERRORMESSAGE15);
        return A32 % B30;
    }
}

library address92 {	//inject NONSTANDARD NAMING
    function ISCONTRACT77(address ACCOUNT45) internal view returns (bool) {	//inject NONSTANDARD NAMING
        bytes32 CODEHASH48;	//inject NONSTANDARD NAMING
        bytes32 ACCOUNTHASH81 = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;	//inject NONSTANDARD NAMING
        // solhint-disable-next-line no-inline-assembly
        assembly { CODEHASH48 := extcodehash(ACCOUNT45) }
        return (CODEHASH48 != 0x0 && CODEHASH48 != ACCOUNTHASH81);
    }
    function TOPAYABLE47(address ACCOUNT45) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(ACCOUNT45));
    }
    function SENDVALUE65(address payable RECIPIENT39, uint256 AMOUNT4) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= AMOUNT4, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool SUCCESS17, ) = RECIPIENT39.call.value(AMOUNT4)("");	//inject NONSTANDARD NAMING
        require(SUCCESS17, "Address: unable to send value, recipient may have reverted");
    }
}

library safeerc2059 {	//inject NONSTANDARD NAMING
    using safemath13 for uint256;
    using address92 for address;

    function SAFETRANSFER30(ierc2093 TOKEN25, address TO76, uint256 VALUE83) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN90(TOKEN25, abi.encodeWithSelector(TOKEN25.TRANSFER37.selector, TO76, VALUE83));
    }

    function SAFETRANSFERFROM76(ierc2093 TOKEN25, address FROM88, address TO76, uint256 VALUE83) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN90(TOKEN25, abi.encodeWithSelector(TOKEN25.TRANSFERFROM19.selector, FROM88, TO76, VALUE83));
    }

    function SAFEAPPROVE32(ierc2093 TOKEN25, address SPENDER52, uint256 VALUE83) internal {	//inject NONSTANDARD NAMING
        require((VALUE83 == 0) || (TOKEN25.ALLOWANCE65(address(this), SPENDER52) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN90(TOKEN25, abi.encodeWithSelector(TOKEN25.APPROVE3.selector, SPENDER52, VALUE83));
    }

    function SAFEINCREASEALLOWANCE32(ierc2093 TOKEN25, address SPENDER52, uint256 VALUE83) internal {	//inject NONSTANDARD NAMING
        uint256 NEWALLOWANCE45 = TOKEN25.ALLOWANCE65(address(this), SPENDER52).ADD27(VALUE83);	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN90(TOKEN25, abi.encodeWithSelector(TOKEN25.APPROVE3.selector, SPENDER52, NEWALLOWANCE45));
    }

    function SAFEDECREASEALLOWANCE48(ierc2093 TOKEN25, address SPENDER52, uint256 VALUE83) internal {	//inject NONSTANDARD NAMING
        uint256 NEWALLOWANCE45 = TOKEN25.ALLOWANCE65(address(this), SPENDER52).SUB57(VALUE83, "SafeERC20: decreased allowance below zero");	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN90(TOKEN25, abi.encodeWithSelector(TOKEN25.APPROVE3.selector, SPENDER52, NEWALLOWANCE45));
    }
    function CALLOPTIONALRETURN90(ierc2093 TOKEN25, bytes memory DATA85) private {	//inject NONSTANDARD NAMING
        require(address(TOKEN25).ISCONTRACT77(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool SUCCESS17, bytes memory RETURNDATA42) = address(TOKEN25).call(DATA85);	//inject NONSTANDARD NAMING
        require(SUCCESS17, "SafeERC20: low-level call failed");

        if (RETURNDATA42.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(RETURNDATA42, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface compound17 {	//inject NONSTANDARD NAMING
    function MINT37 ( uint256 MINTAMOUNT46 ) external returns ( uint256 );	//inject NONSTANDARD NAMING
    function REDEEM71(uint256 REDEEMTOKENS65) external returns (uint256);	//inject NONSTANDARD NAMING
    function EXCHANGERATESTORED22() external view returns (uint);	//inject NONSTANDARD NAMING
}

interface fulcrum27 {	//inject NONSTANDARD NAMING
    function MINT37(address RECEIVER66, uint256 AMOUNT4) external payable returns (uint256 MINTAMOUNT46);	//inject NONSTANDARD NAMING
    function BURN1(address RECEIVER66, uint256 BURNAMOUNT5) external returns (uint256 LOANAMOUNTPAID4);	//inject NONSTANDARD NAMING
    function ASSETBALANCEOF38(address _OWNER43) external view returns (uint256 BALANCE2);	//inject NONSTANDARD NAMING
}

interface ilendingpooladdressesprovider93 {	//inject NONSTANDARD NAMING
    function GETLENDINGPOOL88() external view returns (address);	//inject NONSTANDARD NAMING
}

interface aave60 {	//inject NONSTANDARD NAMING
    function DEPOSIT43(address _RESERVE54, uint256 _AMOUNT50, uint16 _REFERRALCODE69) external;	//inject NONSTANDARD NAMING
}

interface atoken49 {	//inject NONSTANDARD NAMING
    function REDEEM71(uint256 AMOUNT4) external;	//inject NONSTANDARD NAMING
}

interface iiearnmanager83 {	//inject NONSTANDARD NAMING
    function RECOMMEND99(address _TOKEN3) external view returns (	//inject NONSTANDARD NAMING
      string memory CHOICE41,	//inject NONSTANDARD NAMING
      uint256 CAPR5,	//inject NONSTANDARD NAMING
      uint256 IAPR100,	//inject NONSTANDARD NAMING
      uint256 AAPR96,	//inject NONSTANDARD NAMING
      uint256 DAPR97	//inject NONSTANDARD NAMING
    );
}

contract structs50 {	//inject NONSTANDARD NAMING
    struct Val {
        uint256 VALUE83;	//inject NONSTANDARD NAMING
    }

    enum ActionType {
        Deposit,   // supply tokens
        Withdraw  // borrow tokens
    }

    enum AssetDenomination {
        Wei // the amount is denominated in wei
    }

    enum AssetReference {
        Delta // the amount is given as a delta from the current value
    }

    struct AssetAmount {
        bool SIGN32; // true if positive	//inject NONSTANDARD NAMING
        AssetDenomination DENOMINATION0;	//inject NONSTANDARD NAMING
        AssetReference REF97;	//inject NONSTANDARD NAMING
        uint256 VALUE83;	//inject NONSTANDARD NAMING
    }

    struct ActionArgs {
        ActionType ACTIONTYPE60;	//inject NONSTANDARD NAMING
        uint256 ACCOUNTID6;	//inject NONSTANDARD NAMING
        AssetAmount AMOUNT4;	//inject NONSTANDARD NAMING
        uint256 PRIMARYMARKETID93;	//inject NONSTANDARD NAMING
        uint256 SECONDARYMARKETID1;	//inject NONSTANDARD NAMING
        address OTHERADDRESS81;	//inject NONSTANDARD NAMING
        uint256 OTHERACCOUNTID93;	//inject NONSTANDARD NAMING
        bytes DATA85;	//inject NONSTANDARD NAMING
    }

    struct Info {
        address OWNER26;  // The address that owns the account	//inject NONSTANDARD NAMING
        uint256 NUMBER25; // A nonce that allows a single address to control many accounts	//inject NONSTANDARD NAMING
    }

    struct Wei {
        bool SIGN32; // true if positive	//inject NONSTANDARD NAMING
        uint256 VALUE83;	//inject NONSTANDARD NAMING
    }
}

contract dydx100 is structs50 {	//inject NONSTANDARD NAMING
    function GETACCOUNTWEI65(Info memory ACCOUNT45, uint256 MARKETID4) public view returns (Wei memory);	//inject NONSTANDARD NAMING
    function OPERATE53(Info[] memory, ActionArgs[] memory) public;	//inject NONSTANDARD NAMING
}

interface lendingpooladdressesprovider85 {	//inject NONSTANDARD NAMING
    function GETLENDINGPOOL88() external view returns (address);	//inject NONSTANDARD NAMING
    function GETLENDINGPOOLCORE37() external view returns (address);	//inject NONSTANDARD NAMING
}

contract yusdc19 is erc2030, erc20detailed21, reentrancyguard94, structs50, ownable93 {	//inject NONSTANDARD NAMING
  using safeerc2059 for ierc2093;
  using address92 for address;
  using safemath13 for uint256;

  struct Deposit {
    uint256 AMOUNT4;	//inject NONSTANDARD NAMING
    uint256 START33; // Block when it started	//inject NONSTANDARD NAMING
  }

  uint256 public POOL37;	//inject NONSTANDARD NAMING
  address public TOKEN25;	//inject NONSTANDARD NAMING
  address public COMPOUND53;	//inject NONSTANDARD NAMING
  address public FULCRUM19;	//inject NONSTANDARD NAMING
  address public AAVE10;	//inject NONSTANDARD NAMING
  address public AAVEPOOL17;	//inject NONSTANDARD NAMING
  address public AAVETOKEN8;	//inject NONSTANDARD NAMING
  address public DYDX62;	//inject NONSTANDARD NAMING
  uint256 public DTOKEN6;	//inject NONSTANDARD NAMING
  address public APR50;	//inject NONSTANDARD NAMING
  address public CHAI29;	//inject NONSTANDARD NAMING
  // Add other tokens if implemented for another stablecoin
  address public UNISWAPROUTER94 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;	//inject NONSTANDARD NAMING
  address public USDC51 = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;	//inject NONSTANDARD NAMING
  address public WETH0 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;	//inject NONSTANDARD NAMING
  address payable public RETIREMENTYELDTREASURY39;	//inject NONSTANDARD NAMING
  ierc2093 public YELDTOKEN43;	//inject NONSTANDARD NAMING
  uint256 public MAXIMUMTOKENSTOBURN49 = 50000 * 1e18;	//inject NONSTANDARD NAMING
  uint256 public constant minimumeffectamount5 = 5 * 10 ** 18;	//inject NONSTANDARD NAMING

  // When you stake say 1000 USDC for a day that will be your maximum
  // if you stake the next time 300 USDC your maximum will stay the same
  // if you stake 2000 at once it will increase to 2000 USDC
  mapping(bytes32 => uint256) public NUMBEROFPARTICIPANTS77;	//inject NONSTANDARD NAMING


  mapping(address => Deposit) public DEPOSITS12;	//inject NONSTANDARD NAMING
  uint256 public constant onedayinblocks19 = 6500;	//inject NONSTANDARD NAMING
  uint256 public YELDTOREWARDPERDAY12 = 100e18; // 100 YELD per day per 1 million stablecoins padded with 18 zeroes to have that flexibility	//inject NONSTANDARD NAMING
  uint256 public constant onemillion14 = 1e6;	//inject NONSTANDARD NAMING



  enum Lender {
      NONE,
      DYDX,
      COMPOUND,
      AAVE,
      FULCRUM
  }

  Lender public PROVIDER42 = Lender.NONE;	//inject NONSTANDARD NAMING

  constructor (address _YELDTOKEN72, address payable _RETIREMENTYELDTREASURY14) public payable erc20detailed21("yearn USDC", "yUSDC", 18) {	//inject NONSTANDARD NAMING
    TOKEN25 = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    APR50 = address(0xdD6d648C991f7d47454354f4Ef326b04025a48A8);
    DYDX62 = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);
    AAVE10 = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    AAVEPOOL17 = address(0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3);
    FULCRUM19 = address(0x493C57C4763932315A328269E1ADaD09653B9081);
    AAVETOKEN8 = address(0xfC1E690f61EFd961294b3e1Ce3313fBD8aa4f85d);
    COMPOUND53 = address(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    CHAI29 = address(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);
    DTOKEN6 = 3;
    YELDTOKEN43 = ierc2093(_YELDTOKEN72);
    RETIREMENTYELDTREASURY39 = _RETIREMENTYELDTREASURY14;
    APPROVETOKEN12();
  }

  // To receive ETH after converting it from USDC
  function () external payable {}

  function SETRETIREMENTYELDTREASURY49(address payable _TREASURY6) public ONLYOWNER61 {	//inject NONSTANDARD NAMING
    RETIREMENTYELDTREASURY39 = _TREASURY6;
  }

  // In case a new uniswap router version is released
  function SETUNISWAPROUTER20(address _UNISWAPROUTER42) public ONLYOWNER61 {	//inject NONSTANDARD NAMING
    UNISWAPROUTER94 = _UNISWAPROUTER42;
  }

  function EXTRACTTOKENSIFSTUCK53(address _TOKEN3, uint256 _AMOUNT50) public ONLYOWNER61 {	//inject NONSTANDARD NAMING
    ierc2093(_TOKEN3).TRANSFER37(msg.sender, _AMOUNT50);
  }

  function EXTRACTETHIFSTUCK0() public ONLYOWNER61 {	//inject NONSTANDARD NAMING
    OWNER99().transfer(address(this).balance);
  }

  function CHANGEYELDTOREWARDPERDAY13(uint256 _AMOUNT50) public ONLYOWNER61 {	//inject NONSTANDARD NAMING
    YELDTOREWARDPERDAY12 = _AMOUNT50;
  }

  function GETGENERATEDYELDS73() public view returns(uint256) {	//inject NONSTANDARD NAMING
    uint256 BLOCKSPASSED1;	//inject NONSTANDARD NAMING
    if (DEPOSITS12[msg.sender].START33 > 0) {
      BLOCKSPASSED1 = block.number.SUB57(DEPOSITS12[msg.sender].START33);
    } else {
      BLOCKSPASSED1 = 0;
    }
    // This will work because amount is a token with 18 decimals
    // Take the deposit, reduce it by 1 million (by removing 6 zeroes) so you get 1
    // That 1 means get 1 YELD per day (in blocks). Now multiply that 1 by 100 to get 100 YELD per day
    //                       your deposits in dai       div by 1 million * by yeld to reward / 1e18 since yeldToReward is in 18 decimals to be able to provide a smaller price since
    // we can't go below 1 in a variable. You can't make the price 0.00001 that's why we need that 1e18 padding
    uint256 GENERATEDYELDS87 = DEPOSITS12[msg.sender].AMOUNT4.DIV26(onemillion14).MUL24(YELDTOREWARDPERDAY12.DIV26(1e18)).MUL24(BLOCKSPASSED1).DIV26(onedayinblocks19);	//inject NONSTANDARD NAMING
    return GENERATEDYELDS87;
  }

  function EXTRACTYELDEARNINGSWHILEKEEPINGDEPOSIT99() public {	//inject NONSTANDARD NAMING
    require(DEPOSITS12[msg.sender].START33 > 0 && DEPOSITS12[msg.sender].AMOUNT4 > 0, 'Must have deposited stablecoins beforehand');
    uint256 GENERATEDYELDS87 = GETGENERATEDYELDS73();	//inject NONSTANDARD NAMING
    DEPOSITS12[msg.sender] = Deposit(DEPOSITS12[msg.sender].AMOUNT4, block.number);
    YELDTOKEN43.TRANSFER37(msg.sender, GENERATEDYELDS87);
  }

  function DEPOSIT43(uint256 _AMOUNT50)	//inject NONSTANDARD NAMING
      external
      NONREENTRANT47
  {
    require(_AMOUNT50 > 0, "deposit must be greater than 0");
    POOL37 = CALCPOOLVALUEINTOKEN17();
    ierc2093(TOKEN25).SAFETRANSFERFROM76(msg.sender, address(this), _AMOUNT50);

    // Yeld
    if (GETGENERATEDYELDS73() > 0) EXTRACTYELDEARNINGSWHILEKEEPINGDEPOSIT99();
    DEPOSITS12[msg.sender] = Deposit(DEPOSITS12[msg.sender].AMOUNT4.ADD27(_AMOUNT50), block.number);
    // Yeld

    // Calculate pool shares
    uint256 SHARES22 = 0;	//inject NONSTANDARD NAMING
    if (POOL37 == 0) {
      SHARES22 = _AMOUNT50;
      POOL37 = _AMOUNT50;
    } else {
      SHARES22 = (_AMOUNT50.MUL24(_TOTALSUPPLY32)).DIV26(POOL37);
    }
    POOL37 = CALCPOOLVALUEINTOKEN17();
    _MINT79(msg.sender, SHARES22);
  }

  // Converts USDC to ETH and returns how much ETH has been received from Uniswap
  function USDCTOETH25(uint256 _AMOUNT50) internal returns(uint256) {	//inject NONSTANDARD NAMING
      ierc2093(USDC51).SAFEAPPROVE32(UNISWAPROUTER94, 0);
      ierc2093(USDC51).SAFEAPPROVE32(UNISWAPROUTER94, _AMOUNT50);
      address[] memory PATH78 = new address[](2);	//inject NONSTANDARD NAMING
      PATH78[0] = USDC51;
      PATH78[1] = WETH0;
      // swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
      // 'amounts' is an array where [0] is input USDC amount and [1] is the resulting ETH after the conversion
      // even tho we've specified the WETH address, we'll receive ETH since that's how it works on uniswap
      // https://uniswap.org/docs/v2/smart-contracts/router02/#swapexacttokensforeth
      uint[] memory AMOUNTS56 = iuniswap2(UNISWAPROUTER94).SWAPEXACTTOKENSFORETH53(_AMOUNT50, uint(0), PATH78, address(this), now.ADD27(1800));	//inject NONSTANDARD NAMING
      return AMOUNTS56[1];
  }

  // Buys YELD tokens paying in ETH on Uniswap and removes them from circulation
  // Returns how many YELD tokens have been burned
  function BUYNBURN98(uint256 _ETHTOSWAP66) internal returns(uint256) {	//inject NONSTANDARD NAMING
    address[] memory PATH78 = new address[](2);	//inject NONSTANDARD NAMING
    PATH78[0] = WETH0;
    PATH78[1] = address(YELDTOKEN43);
    // Burns the tokens by taking them out of circulation, sending them to the 0x0 address
    uint[] memory AMOUNTS56 = iuniswap2(UNISWAPROUTER94).SWAPEXACTETHFORTOKENS6.value(_ETHTOSWAP66)(uint(0), PATH78, address(0), now.ADD27(1800));	//inject NONSTANDARD NAMING
    return AMOUNTS56[1];
  }

  // No rebalance implementation for lower fees and faster swaps
  function WITHDRAW27(uint256 _SHARES43)	//inject NONSTANDARD NAMING
      external
      NONREENTRANT47
  {
      require(_SHARES43 > 0, "withdraw must be greater than 0");
      uint256 IBALANCE43 = BALANCEOF25(msg.sender);	//inject NONSTANDARD NAMING
      require(_SHARES43 <= IBALANCE43, "insufficient balance");
      POOL37 = CALCPOOLVALUEINTOKEN17();
      uint256 R82 = (POOL37.MUL24(_SHARES43)).DIV26(_TOTALSUPPLY32);	//inject NONSTANDARD NAMING
      _BALANCES15[msg.sender] = _BALANCES15[msg.sender].SUB57(_SHARES43, "redeem amount exceeds balance");
      _TOTALSUPPLY32 = _TOTALSUPPLY32.SUB57(_SHARES43);
      emit TRANSFER22(msg.sender, address(0), _SHARES43);
      uint256 B30 = ierc2093(TOKEN25).BALANCEOF25(address(this));	//inject NONSTANDARD NAMING
      if (B30 < R82) {
        _WITHDRAWSOME38(R82.SUB57(B30));
      }

      // Yeld
      uint256 GENERATEDYELDS87 = GETGENERATEDYELDS73();	//inject NONSTANDARD NAMING
      uint256 HALFPROFITS96 = (R82.SUB57(DEPOSITS12[msg.sender].AMOUNT4, '#3 Half profits sub error')).DIV26(2);	//inject NONSTANDARD NAMING
      DEPOSITS12[msg.sender] = Deposit(DEPOSITS12[msg.sender].AMOUNT4.SUB57(_SHARES43), block.number);
      YELDTOKEN43.TRANSFER37(msg.sender, GENERATEDYELDS87);

      // Take a portion of the profits for the buy and burn and retirement yeld
      // Convert half the USDC earned into ETH for the protocol algorithms
      if (HALFPROFITS96 > minimumeffectamount5) {
        uint256 STAKINGPROFITS48 = USDCTOETH25(HALFPROFITS96);	//inject NONSTANDARD NAMING
        uint256 TOKENSALREADYBURNED29 = YELDTOKEN43.BALANCEOF25(address(0));	//inject NONSTANDARD NAMING
        if (TOKENSALREADYBURNED29 < MAXIMUMTOKENSTOBURN49) {
          // 98% is the 49% doubled since we already took the 50%
          uint256 ETHTOSWAP53 = STAKINGPROFITS48.MUL24(98).DIV26(100);	//inject NONSTANDARD NAMING
          // Buy and burn only applies up to 50k tokens burned
          BUYNBURN98(ETHTOSWAP53);
          // 1% for the Retirement Yield
          uint256 RETIREMENTYELD83 = STAKINGPROFITS48.MUL24(2).DIV26(100);	//inject NONSTANDARD NAMING
          // Send to the treasury
          RETIREMENTYELDTREASURY39.transfer(RETIREMENTYELD83);
        } else {
          // If we've reached the maximum burn point, send half the profits to the treasury to reward holders
          uint256 RETIREMENTYELD83 = STAKINGPROFITS48;	//inject NONSTANDARD NAMING
          // Send to the treasury
          RETIREMENTYELDTREASURY39.transfer(RETIREMENTYELD83);
        }
      }
      // Yeld

      ierc2093(TOKEN25).SAFETRANSFER30(msg.sender, R82);
      POOL37 = CALCPOOLVALUEINTOKEN17();
  }

  function RECOMMEND99() public view returns (Lender) {	//inject NONSTANDARD NAMING
    (,uint256 CAPR5,uint256 IAPR100,uint256 AAPR96,uint256 DAPR97) = iiearnmanager83(APR50).RECOMMEND99(TOKEN25);	//inject NONSTANDARD NAMING
    uint256 MAX28 = 0;	//inject NONSTANDARD NAMING
    if (CAPR5 > MAX28) {
      MAX28 = CAPR5;
    }
    if (IAPR100 > MAX28) {
      MAX28 = IAPR100;
    }
    if (AAPR96 > MAX28) {
      MAX28 = AAPR96;
    }
    if (DAPR97 > MAX28) {
      MAX28 = DAPR97;
    }

    Lender NEWPROVIDER38 = Lender.NONE;	//inject NONSTANDARD NAMING
    if (MAX28 == CAPR5) {
      NEWPROVIDER38 = Lender.COMPOUND;
    } else if (MAX28 == IAPR100) {
      NEWPROVIDER38 = Lender.FULCRUM;
    } else if (MAX28 == AAPR96) {
      NEWPROVIDER38 = Lender.AAVE;
    } else if (MAX28 == DAPR97) {
      NEWPROVIDER38 = Lender.DYDX;
    }
    return NEWPROVIDER38;
  }

  function GETAAVE86() public view returns (address) {	//inject NONSTANDARD NAMING
    return lendingpooladdressesprovider85(AAVE10).GETLENDINGPOOL88();
  }
  function GETAAVECORE62() public view returns (address) {	//inject NONSTANDARD NAMING
    return lendingpooladdressesprovider85(AAVE10).GETLENDINGPOOLCORE37();
  }

  function APPROVETOKEN12() public {	//inject NONSTANDARD NAMING
      ierc2093(TOKEN25).SAFEAPPROVE32(COMPOUND53, uint(-1));
      ierc2093(TOKEN25).SAFEAPPROVE32(DYDX62, uint(-1));
      ierc2093(TOKEN25).SAFEAPPROVE32(GETAAVECORE62(), uint(-1));
      ierc2093(TOKEN25).SAFEAPPROVE32(FULCRUM19, uint(-1));
  }

  function BALANCE62() public view returns (uint256) {	//inject NONSTANDARD NAMING
    return ierc2093(TOKEN25).BALANCEOF25(address(this));
  }
  function BALANCEDYDXAVAILABLE58() public view returns (uint256) {	//inject NONSTANDARD NAMING
      return ierc2093(TOKEN25).BALANCEOF25(DYDX62);
  }
  function BALANCEDYDX47() public view returns (uint256) {	//inject NONSTANDARD NAMING
      Wei memory BAL85 = dydx100(DYDX62).GETACCOUNTWEI65(Info(address(this), 0), DTOKEN6);	//inject NONSTANDARD NAMING
      return BAL85.VALUE83;
  }
  function BALANCECOMPOUND27() public view returns (uint256) {	//inject NONSTANDARD NAMING
      return ierc2093(COMPOUND53).BALANCEOF25(address(this));
  }
  function BALANCECOMPOUNDINTOKEN38() public view returns (uint256) {	//inject NONSTANDARD NAMING
    // Mantisa 1e18 to decimals
    uint256 B30 = BALANCECOMPOUND27();	//inject NONSTANDARD NAMING
    if (B30 > 0) {
      B30 = B30.MUL24(compound17(COMPOUND53).EXCHANGERATESTORED22()).DIV26(1e18);
    }
    return B30;
  }
  function BALANCEFULCRUMAVAILABLE62() public view returns (uint256) {	//inject NONSTANDARD NAMING
      return ierc2093(CHAI29).BALANCEOF25(FULCRUM19);
  }
  function BALANCEFULCRUMINTOKEN93() public view returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 B30 = BALANCEFULCRUM60();	//inject NONSTANDARD NAMING
    if (B30 > 0) {
      B30 = fulcrum27(FULCRUM19).ASSETBALANCEOF38(address(this));
    }
    return B30;
  }
  function BALANCEFULCRUM60() public view returns (uint256) {	//inject NONSTANDARD NAMING
    return ierc2093(FULCRUM19).BALANCEOF25(address(this));
  }
  function BALANCEAAVEAVAILABLE0() public view returns (uint256) {	//inject NONSTANDARD NAMING
      return ierc2093(TOKEN25).BALANCEOF25(AAVEPOOL17);
  }
  function BALANCEAAVE23() public view returns (uint256) {	//inject NONSTANDARD NAMING
    return ierc2093(AAVETOKEN8).BALANCEOF25(address(this));
  }

  function REBALANCE91() public {	//inject NONSTANDARD NAMING
    Lender NEWPROVIDER38 = RECOMMEND99();	//inject NONSTANDARD NAMING

    if (NEWPROVIDER38 != PROVIDER42) {
      _WITHDRAWALL34();
    }

    if (BALANCE62() > 0) {
      if (NEWPROVIDER38 == Lender.DYDX) {
        _SUPPLYDYDX52(BALANCE62());
      } else if (NEWPROVIDER38 == Lender.FULCRUM) {
        _SUPPLYFULCRUM48(BALANCE62());
      } else if (NEWPROVIDER38 == Lender.COMPOUND) {
        _SUPPLYCOMPOUND47(BALANCE62());
      } else if (NEWPROVIDER38 == Lender.AAVE) {
        _SUPPLYAAVE98(BALANCE62());
      }
    }

    PROVIDER42 = NEWPROVIDER38;
  }

  function _WITHDRAWALL34() internal {	//inject NONSTANDARD NAMING
    uint256 AMOUNT4 = BALANCECOMPOUND27();	//inject NONSTANDARD NAMING
    if (AMOUNT4 > 0) {
      _WITHDRAWSOMECOMPOUND30(BALANCECOMPOUNDINTOKEN38().SUB57(1));
    }
    AMOUNT4 = BALANCEDYDX47();
    if (AMOUNT4 > 0) {
      if (AMOUNT4 > BALANCEDYDXAVAILABLE58()) {
        AMOUNT4 = BALANCEDYDXAVAILABLE58();
      }
      _WITHDRAWDYDX0(AMOUNT4);
    }
    AMOUNT4 = BALANCEFULCRUM60();
    if (AMOUNT4 > 0) {
      if (AMOUNT4 > BALANCEFULCRUMAVAILABLE62().SUB57(1)) {
        AMOUNT4 = BALANCEFULCRUMAVAILABLE62().SUB57(1);
      }
      _WITHDRAWSOMEFULCRUM68(AMOUNT4);
    }
    AMOUNT4 = BALANCEAAVE23();
    if (AMOUNT4 > 0) {
      if (AMOUNT4 > BALANCEAAVEAVAILABLE0()) {
        AMOUNT4 = BALANCEAAVEAVAILABLE0();
      }
      _WITHDRAWAAVE10(AMOUNT4);
    }
  }

  function _WITHDRAWSOMECOMPOUND30(uint256 _AMOUNT50) internal {	//inject NONSTANDARD NAMING
    uint256 B30 = BALANCECOMPOUND27();	//inject NONSTANDARD NAMING
    uint256 BT79 = BALANCECOMPOUNDINTOKEN38();	//inject NONSTANDARD NAMING
    require(BT79 >= _AMOUNT50, "insufficient funds");
    // can have unintentional rounding errors
    uint256 AMOUNT4 = (B30.MUL24(_AMOUNT50)).DIV26(BT79).ADD27(1);	//inject NONSTANDARD NAMING
    _WITHDRAWCOMPOUND82(AMOUNT4);
  }

  function _WITHDRAWSOMEFULCRUM68(uint256 _AMOUNT50) internal {	//inject NONSTANDARD NAMING
    uint256 B30 = BALANCEFULCRUM60();	//inject NONSTANDARD NAMING
    uint256 BT79 = BALANCEFULCRUMINTOKEN93();	//inject NONSTANDARD NAMING
    require(BT79 >= _AMOUNT50, "insufficient funds");
    // can have unintentional rounding errors
    uint256 AMOUNT4 = (B30.MUL24(_AMOUNT50)).DIV26(BT79).ADD27(1);	//inject NONSTANDARD NAMING
    _WITHDRAWFULCRUM65(AMOUNT4);
  }


  function _WITHDRAWSOME38(uint256 _AMOUNT50) internal returns (bool) {	//inject NONSTANDARD NAMING
    uint256 ORIGAMOUNT32 = _AMOUNT50;	//inject NONSTANDARD NAMING

    uint256 AMOUNT4 = BALANCECOMPOUND27();	//inject NONSTANDARD NAMING
    if (AMOUNT4 > 0) {
      if (_AMOUNT50 > BALANCECOMPOUNDINTOKEN38().SUB57(1)) {
        _WITHDRAWSOMECOMPOUND30(BALANCECOMPOUNDINTOKEN38().SUB57(1));
        _AMOUNT50 = ORIGAMOUNT32.SUB57(ierc2093(TOKEN25).BALANCEOF25(address(this)));
      } else {
        _WITHDRAWSOMECOMPOUND30(_AMOUNT50);
        return true;
      }
    }

    AMOUNT4 = BALANCEDYDX47();
    if (AMOUNT4 > 0) {
      if (_AMOUNT50 > BALANCEDYDXAVAILABLE58()) {
        _WITHDRAWDYDX0(BALANCEDYDXAVAILABLE58());
        _AMOUNT50 = ORIGAMOUNT32.SUB57(ierc2093(TOKEN25).BALANCEOF25(address(this)));
      } else {
        _WITHDRAWDYDX0(_AMOUNT50);
        return true;
      }
    }

    AMOUNT4 = BALANCEFULCRUM60();
    if (AMOUNT4 > 0) {
      if (_AMOUNT50 > BALANCEFULCRUMAVAILABLE62().SUB57(1)) {
        AMOUNT4 = BALANCEFULCRUMAVAILABLE62().SUB57(1);
        _WITHDRAWSOMEFULCRUM68(BALANCEFULCRUMAVAILABLE62().SUB57(1));
        _AMOUNT50 = ORIGAMOUNT32.SUB57(ierc2093(TOKEN25).BALANCEOF25(address(this)));
      } else {
        _WITHDRAWSOMEFULCRUM68(AMOUNT4);
        return true;
      }
    }

    AMOUNT4 = BALANCEAAVE23();
    if (AMOUNT4 > 0) {
      if (_AMOUNT50 > BALANCEAAVEAVAILABLE0()) {
        _WITHDRAWAAVE10(BALANCEAAVEAVAILABLE0());
        _AMOUNT50 = ORIGAMOUNT32.SUB57(ierc2093(TOKEN25).BALANCEOF25(address(this)));
      } else {
        _WITHDRAWAAVE10(_AMOUNT50);
        return true;
      }
    }

    return true;
  }

  function _SUPPLYDYDX52(uint256 AMOUNT4) internal {	//inject NONSTANDARD NAMING
      Info[] memory INFOS35 = new Info[](1);	//inject NONSTANDARD NAMING
      INFOS35[0] = Info(address(this), 0);

      AssetAmount memory AMT17 = AssetAmount(true, AssetDenomination.Wei, AssetReference.Delta, AMOUNT4);	//inject NONSTANDARD NAMING
      ActionArgs memory ACT61;	//inject NONSTANDARD NAMING
      ACT61.ACTIONTYPE60 = ActionType.Deposit;
      ACT61.ACCOUNTID6 = 0;
      ACT61.AMOUNT4 = AMT17;
      ACT61.PRIMARYMARKETID93 = DTOKEN6;
      ACT61.OTHERADDRESS81 = address(this);

      ActionArgs[] memory ARGS40 = new ActionArgs[](1);	//inject NONSTANDARD NAMING
      ARGS40[0] = ACT61;

      dydx100(DYDX62).OPERATE53(INFOS35, ARGS40);
  }

  function _SUPPLYAAVE98(uint AMOUNT4) internal {	//inject NONSTANDARD NAMING
      aave60(GETAAVE86()).DEPOSIT43(TOKEN25, AMOUNT4, 0);
  }
  function _SUPPLYFULCRUM48(uint AMOUNT4) internal {	//inject NONSTANDARD NAMING
      require(fulcrum27(FULCRUM19).MINT37(address(this), AMOUNT4) > 0, "FULCRUM: supply failed");
  }
  function _SUPPLYCOMPOUND47(uint AMOUNT4) internal {	//inject NONSTANDARD NAMING
      require(compound17(COMPOUND53).MINT37(AMOUNT4) == 0, "COMPOUND: supply failed");
  }
  function _WITHDRAWAAVE10(uint AMOUNT4) internal {	//inject NONSTANDARD NAMING
      atoken49(AAVETOKEN8).REDEEM71(AMOUNT4);
  }
  function _WITHDRAWFULCRUM65(uint AMOUNT4) internal {	//inject NONSTANDARD NAMING
      require(fulcrum27(FULCRUM19).BURN1(address(this), AMOUNT4) > 0, "FULCRUM: withdraw failed");
  }
  function _WITHDRAWCOMPOUND82(uint AMOUNT4) internal {	//inject NONSTANDARD NAMING
      require(compound17(COMPOUND53).REDEEM71(AMOUNT4) == 0, "COMPOUND: withdraw failed");
  }

  function _WITHDRAWDYDX0(uint256 AMOUNT4) internal {	//inject NONSTANDARD NAMING
      Info[] memory INFOS35 = new Info[](1);	//inject NONSTANDARD NAMING
      INFOS35[0] = Info(address(this), 0);

      AssetAmount memory AMT17 = AssetAmount(false, AssetDenomination.Wei, AssetReference.Delta, AMOUNT4);	//inject NONSTANDARD NAMING
      ActionArgs memory ACT61;	//inject NONSTANDARD NAMING
      ACT61.ACTIONTYPE60 = ActionType.Withdraw;
      ACT61.ACCOUNTID6 = 0;
      ACT61.AMOUNT4 = AMT17;
      ACT61.PRIMARYMARKETID93 = DTOKEN6;
      ACT61.OTHERADDRESS81 = address(this);

      ActionArgs[] memory ARGS40 = new ActionArgs[](1);	//inject NONSTANDARD NAMING
      ARGS40[0] = ACT61;

      dydx100(DYDX62).OPERATE53(INFOS35, ARGS40);
  }

  function CALCPOOLVALUEINTOKEN17() public view returns (uint) {	//inject NONSTANDARD NAMING
    return BALANCECOMPOUNDINTOKEN38()
      .ADD27(BALANCEFULCRUMINTOKEN93())
      .ADD27(BALANCEDYDX47())
      .ADD27(BALANCEAAVE23())
      .ADD27(BALANCE62());
  }

  function GETPRICEPERFULLSHARE16() public view returns (uint) {	//inject NONSTANDARD NAMING
    uint _POOL79 = CALCPOOLVALUEINTOKEN17();	//inject NONSTANDARD NAMING
    return _POOL79.MUL24(1e18).DIV26(_TOTALSUPPLY32);
  }
}