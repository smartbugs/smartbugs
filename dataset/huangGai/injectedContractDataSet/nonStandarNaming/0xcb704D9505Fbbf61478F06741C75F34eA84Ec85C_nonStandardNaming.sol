                                                                 

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface ERC20Interface {
    function ALLOWANCE870(address, address) external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF872(address) external view returns (uint);	//inject NONSTANDARD NAMING
    function APPROVE601(address, uint) external;	//inject NONSTANDARD NAMING
    function TRANSFER527(address, uint) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM476(address, address, uint) external returns (bool);	//inject NONSTANDARD NAMING
    function DEPOSIT946() external payable;	//inject NONSTANDARD NAMING
    function WITHDRAW213(uint) external;	//inject NONSTANDARD NAMING
}


interface SoloMarginContract {

    struct Info {
        address owner;
        uint256 number;
    }


    struct Wei {
        bool sign;
        uint256 value;
    }

    struct Price {
        uint256 value;
    }

    struct TotalPar {
        uint128 borrow;
        uint128 supply;
    }

    struct Index {
        uint96 borrow;
        uint96 supply;
        uint32 lastUpdate;
    }

    function GETMARKETPRICE921(uint256 marketId) external view returns (Price memory);	//inject NONSTANDARD NAMING
    function GETACCOUNTWEI314(Info calldata account, uint256 marketId) external view returns (Wei memory);	//inject NONSTANDARD NAMING
    function GETMARKETTOTALPAR951(uint256 marketId) external view returns (TotalPar memory);	//inject NONSTANDARD NAMING
    function GETMARKETCURRENTINDEX242(uint256 marketId) external view returns (Index memory);	//inject NONSTANDARD NAMING
}

contract DSMath {

    function ADD117(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require((z = x + y) >= x, "math-not-safe");
    }

    function SUB535(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        z = x - y <= x ? x - y : 0;
    }

    function MUL175(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require(y == 0 || (z = x * y) / y == x, "math-not-safe");
    }

    uint constant wad521 = 10 ** 18;	//inject NONSTANDARD NAMING
    uint constant ray706 = 10 ** 27;	//inject NONSTANDARD NAMING

    function RMUL16(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        z = ADD117(MUL175(x, y), ray706 / 2) / ray706;
    }

    function WMUL84(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        z = ADD117(MUL175(x, y), wad521 / 2) / wad521;
    }

    function RDIV668(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        z = ADD117(MUL175(x, ray706), y / 2) / y;
    }

    function WDIV193(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        z = ADD117(MUL175(x, wad521), y / 2) / y;
    }

}

contract Helpers is DSMath{

                                                
    function GETSOLOADDRESS152() public pure returns (address addr) {	//inject NONSTANDARD NAMING
        addr = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;
    }

                                              
    function GETACCOUNTARGS93(address owner) internal pure returns (SoloMarginContract.Info memory) {	//inject NONSTANDARD NAMING
        SoloMarginContract.Info[] memory accounts = new SoloMarginContract.Info[](1);
        accounts[0] = (SoloMarginContract.Info(owner, 0));
        return accounts[0];
    }

    struct DydxData {
        uint tokenPrice;
        uint supplyBalance;
        uint borrowBalance;
        uint tokenUtil;
    }
}


contract Resolver is Helpers {
    function GETPOSITION635(address user, uint[] memory marketId) public view returns(DydxData[] memory) {	//inject NONSTANDARD NAMING
        SoloMarginContract solo = SoloMarginContract(GETSOLOADDRESS152());
        DydxData[] memory tokensData = new DydxData[](marketId.length);
        for (uint i = 0; i < marketId.length; i++) {
            uint id = marketId[i];
            SoloMarginContract.Wei memory tokenBal = solo.GETACCOUNTWEI314(GETACCOUNTARGS93(user), id);
            SoloMarginContract.TotalPar memory totalPar = solo.GETMARKETTOTALPAR951(id);
            SoloMarginContract.Index memory rateIndex = solo.GETMARKETCURRENTINDEX242(id);

            tokensData[i] = DydxData(
                solo.GETMARKETPRICE921(id).value,
                tokenBal.sign ? tokenBal.value : 0,
                !tokenBal.sign ? tokenBal.value : 0,
                WDIV193(WMUL84(totalPar.borrow, rateIndex.borrow), WMUL84(totalPar.supply, rateIndex.supply))
            );
        }
        return tokensData;
    }
}

contract InstaDydxResolver is Resolver {
    string public constant name822 = "Dydx-Resolver-v1";	//inject NONSTANDARD NAMING
}