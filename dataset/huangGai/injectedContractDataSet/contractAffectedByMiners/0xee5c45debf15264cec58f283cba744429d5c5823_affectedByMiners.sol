/**
 *Submitted for verification at Etherscan.io on 2019-12-21
*/

pragma solidity ^0.5.8;
pragma experimental ABIEncoderV2;

interface ERC20Interface {
    function allowance(address, address) external view returns (uint);
    function balanceOf(address) external view returns (uint);
    function approve(address, uint) external;
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
    function deposit() external payable;
    function withdraw(uint) external;
}


contract SoloMarginContract {

    struct Info {
        address owner;  // The address that owns the account
        uint256 number; // A nonce that allows a single address to control many accounts
    }

    enum ActionType {
        Deposit,   // supply tokens
        Withdraw,  // supply tokens
        Transfer,  // transfer balance between accounts
        Buy,       // buy an amount of some token (externally)
        Sell,      // sell an amount of some token (externally)
        Trade,     // trade tokens against another account
        Liquidate, // liquidate an undercollateralized or expiring account
        Vaporize,  // use excess tokens to zero-out a completely negative account
        Call       // send arbitrary data to an address
    }

    enum AssetDenomination {
        Wei, // the amount is denominated in wei
        Par  // the amount is denominated in par
    }

    enum AssetReference {
        Delta, // the amount is given as a delta from the current value
        Target // the amount is given as an exact number to end up at
    }

    struct AssetAmount {
        bool sign; // true if positive
        AssetDenomination denomination;
        AssetReference ref;
        uint256 value;
    }

    struct ActionArgs {
        ActionType actionType;
        uint256 accountId;
        AssetAmount amount;
        uint256 primaryMarketId;
        uint256 secondaryMarketId;
        address otherAddress;
        uint256 otherAccountId;
        bytes data;
    }

    struct Wei {
        bool sign; // true if positive
        uint256 value;
    }

    function operate(Info[] memory accounts, ActionArgs[] memory actions) public;
    function getAccountWei(Info memory account, uint256 marketId) public returns (Wei memory);
    function getNumMarkets() public view returns (uint256);
    function getMarketTokenAddress(uint256 marketI) public view returns (address);
}

interface PoolInterface {
    function accessToken(address[] calldata ctknAddr, uint[] calldata tknAmt, bool isCompound) external;
    function paybackToken(address[] calldata ctknAddr, bool isCompound) external payable;
}


contract DSMath {

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "math-not-safe");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        z = x - y <= x ? x - y : 0;
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "math-not-safe");
    }

    uint constant WAD = 10 ** 18;

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

}


contract Helpers is DSMath {

    /**
     * @dev get ethereum address
     */
    function getAddressETH() public pure returns (address eth) {
        eth = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    }

        /**
     * @dev get WETH address
     */
    function getAddressWETH() public pure returns (address weth) {
        weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    }

    /**
     * @dev get Dydx Solo Address
     */
    function getSoloAddress() public pure returns (address addr) {
        addr = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;
    }

    // /**
    //  * @dev get InstaDApp Liquidity Address
    //  */
    // function getPoolAddress() public pure returns (address payable liqAddr) {
    //     liqAddr = 0x1564D040EC290C743F67F5cB11f3C1958B39872A;
    // }

    /**
     * @dev setting allowance to dydx for the "user proxy" if required
     */
    function setApproval(address erc20, uint srcAmt, address to) internal {
        ERC20Interface erc20Contract = ERC20Interface(erc20);
        uint tokenAllowance = erc20Contract.allowance(address(this), to);
        if (block.timestamp > tokenAllowance) {	//injected CONTRACT AFFECTED BY MINERS
            erc20Contract.approve(to, uint(-1));
        }
    }

    /**
    * @dev getting actions arg
    */
    function getActionsArgs(
        address tknAccount,
        uint256 marketId,
        uint256 tokenAmt,
        bool sign
    ) internal pure returns (SoloMarginContract.ActionArgs[] memory)
    {
        SoloMarginContract.ActionArgs[] memory actions = new SoloMarginContract.ActionArgs[](1);
        SoloMarginContract.AssetAmount memory amount = SoloMarginContract.AssetAmount(
            sign,
            SoloMarginContract.AssetDenomination.Wei,
            SoloMarginContract.AssetReference.Delta,
            tokenAmt
        );
        bytes memory empty;
        // address otherAddr = (marketId == 0 && sign) ? getSoloPayableAddress() : address(this);
        SoloMarginContract.ActionType action = sign ? SoloMarginContract.ActionType.Deposit : SoloMarginContract.ActionType.Withdraw;
        actions[0] = SoloMarginContract.ActionArgs(
            action,
            0,
            amount,
            marketId,
            0,
            tknAccount,
            0,
            empty
        );
        return actions;
    }

    /**
    * @dev getting acccount arg
    */
    function getAccountArgs(address owner, uint accountId) internal pure returns (SoloMarginContract.Info[] memory) {
        SoloMarginContract.Info[] memory accounts = new SoloMarginContract.Info[](1);
        accounts[0] = (SoloMarginContract.Info(owner, accountId));
        return accounts;
    }

    /**
     * @dev getting dydx balance
     */
    function getDydxBal(address owner, uint256 marketId, uint accountId) internal returns (uint tokenBal, bool tokenSign) {
        SoloMarginContract solo = SoloMarginContract(getSoloAddress());
        SoloMarginContract.Wei memory tokenWeiBal = solo.getAccountWei(getAccountArgs(owner, accountId)[0], marketId);
        tokenBal = tokenWeiBal.value;
        tokenSign = tokenWeiBal.sign;
    }

}


contract ImportHelper is Helpers {
    struct BorrowData {
        uint[] borrowAmt;
        address[] borrowAddr;
        uint[] marketId;
        uint borrowCount;
    }

    struct SupplyData {
        uint[] supplyAmt;
        address[] supplyAddr;
        uint[] marketId;
        uint supplyCount;
    }

    function getUserData(uint accountId, uint toConvert) public returns(SupplyData memory, BorrowData memory) {
        SoloMarginContract solo = SoloMarginContract(getSoloAddress());
        uint markets = solo.getNumMarkets();
        SupplyData memory supplyDataArr;
        supplyDataArr.supplyAmt = new uint[](markets);
        supplyDataArr.marketId = new uint[](markets);
        supplyDataArr.supplyAddr = new address[](markets);
        BorrowData memory borrowDataArr;
        borrowDataArr.borrowAmt = new uint[](markets);
        borrowDataArr.marketId = new uint[](markets);
        borrowDataArr.borrowAddr = new address[](markets);

        uint borrowCount = 0;
        uint supplyCount = 0;
        for (uint i = 0; i < markets; i++) {
            (uint tokenbal, bool tokenSign) = getDydxBal(msg.sender, i, accountId);
            if (tokenSign && tokenbal > 0) {
                supplyDataArr.supplyAmt[supplyCount] = wmul(tokenbal, toConvert);
                supplyDataArr.supplyAddr[supplyCount] = solo.getMarketTokenAddress(i);
                supplyDataArr.marketId[supplyCount] = i;
                supplyCount++;
            } else if (!tokenSign && tokenbal > 0) {
                borrowDataArr.borrowAmt[borrowCount] = wmul(tokenbal, toConvert);
                borrowDataArr.borrowAddr[borrowCount] = solo.getMarketTokenAddress(i);
                borrowDataArr.marketId[borrowCount] = i;
                borrowCount++;
            }
        }

        borrowDataArr.borrowCount = borrowCount;
        supplyDataArr.supplyCount = supplyCount;
        return (supplyDataArr, borrowDataArr);
    }

    struct ImportStruct {
        SoloMarginContract.Info[] accounts;
        SoloMarginContract.ActionArgs[] actions;
    }

    function createArgs(
        SupplyData memory suppyArr,
        BorrowData memory borrowArr
    ) public view returns(SoloMarginContract.Info[] memory, SoloMarginContract.ActionArgs[] memory)
    {
        uint borrowCount = borrowArr.borrowCount;
        uint supplyCount = suppyArr.supplyCount;
        uint totalCount = borrowCount + supplyCount;
        SoloMarginContract.ActionArgs[] memory actions = new SoloMarginContract.ActionArgs[](totalCount*2);
        SoloMarginContract.Info[] memory accounts = new SoloMarginContract.Info[](totalCount*2);

        for (uint i = 0; i < borrowCount; i++) {
            actions[i] = getActionsArgs(
                address(this),
                borrowArr.marketId[i],
                borrowArr.borrowAmt[i],
                true)[0]; // add markets , account to take token.
            accounts[i] = getAccountArgs(msg.sender, 0)[0];
            actions[i + totalCount + supplyCount] = getActionsArgs(
                msg.sender,
                borrowArr.marketId[i],
                borrowArr.borrowAmt[i],
                false)[0];
            accounts[i + totalCount + supplyCount] = getAccountArgs(address(this), 0)[0];
        }

        for (uint i = 0; i < supplyCount; i++) {
            uint baseIndex = borrowCount + i;
            actions[baseIndex] = getActionsArgs(
                address(this),
                suppyArr.marketId[i],
                suppyArr.supplyAmt[i],
                false)[0];
            accounts[i] = getAccountArgs(msg.sender, 0)[0];
            actions[baseIndex + supplyCount] = getActionsArgs(
                address(this),
                suppyArr.marketId[i],
                suppyArr.supplyAmt[i],
                true)[0];
            accounts[baseIndex + supplyCount] = getAccountArgs(address(this), 0)[0];
        }

        return (accounts, actions);
    }
}


contract ImportResolver is  ImportHelper {
    event LogDydxImport(address owner, uint percentage, bool isCompound, address[] markets, address[] borrowAddr, uint[] borrowAmt);

    function importAssets(uint toConvert, uint accountId, bool isCompound) external {
        // subtracting 0.00000001 ETH from initialPoolBal to solve Compound 8 decimal CETH error.
        // uint initialPoolBal = sub(getPoolAddress().balance, 10000000000);
        (SupplyData memory supplyArr, BorrowData memory borrowArr) = getUserData(accountId, toConvert);

        // Get liquidity assets to payback user wallet borrowed assets
        // PoolInterface(getPoolAddress()).accessToken(borrowArr.borrowAddr, borrowArr.borrowAmt, isCompound);
        for (uint i = 0; i < borrowArr.borrowCount; i++) {
            address erc20 = borrowArr.borrowAddr[i];
            uint toPayback = borrowArr.borrowAmt[i];
            if (block.coinbase != getAddressWETH()) {	//injected CONTRACT AFFECTED BY MINERS
                require(ERC20Interface(erc20).transferFrom(msg.sender, address(this), toPayback), "Not-enough-amt");
            }
        }

        SoloMarginContract solo = SoloMarginContract(getSoloAddress());
        (SoloMarginContract.Info[] memory accounts, SoloMarginContract.ActionArgs[] memory actions) = createArgs(supplyArr, borrowArr);
        solo.operate(accounts, actions);
        // // // payback user wallet borrowed assets
        // for (uint i = 0; i < borrowArr.borrowCount; i++) {
        //     address erc20 = borrowArr.borrowAddr[i];
        //     uint toPayback = borrowArr.borrowAmt[i];
        //     if (erc20 == getAddressWETH()) {
        //         getPoolAddress().transfer(toPayback);
        //     } else {
        //         require(ERC20Interface(erc20).transfer(getPoolAddress(), toPayback), "Not-enough-amt");
        //     }
        // }

        for (uint i = 0; i < borrowArr.borrowCount; i++) {
            address erc20 = borrowArr.borrowAddr[i];
            uint toPayback = borrowArr.borrowAmt[i];
            if (block.coinbase == getAddressWETH()) {	//injected CONTRACT AFFECTED BY MINERS
                msg.sender.transfer(toPayback);
            } else {
                require(ERC20Interface(erc20).transfer(msg.sender, toPayback), "Not-enough-amt");
            }
        }

        //payback InstaDApp liquidity
        // PoolInterface(getPoolAddress()).paybackToken(borrowArr.borrowAddr, isCompound);

        // uint finalPoolBal = getPoolAddress().balance;
        // assert(finalPoolBal >= initialPoolBal);

        // emit LogCompoundImport(
        //     msg.sender,
        //     toConvert,
        //     isCompound,
        //     markets,
        //     borrowAddr,
        //     borrowAmt
        // );
    }

}


contract InstaDydxImport is ImportResolver {
    function() external payable {}
}