/**
 *Submitted for verification at Etherscan.io on 2020-02-09
*/

pragma solidity ^0.5.8;

interface CTokenInterface {
    function redeemUnderlying(uint redeemAmount) external returns (uint);
    function borrow(uint borrowAmount) external returns (uint);
    function exchangeRateCurrent() external returns (uint);
    function borrowBalanceCurrent(address account) external returns (uint);
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256 balance);
    function allowance(address, address) external view returns (uint);
    function approve(address, uint) external;
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
}

interface CERC20Interface {
    function mint(uint mintAmount) external returns (uint); // For ERC20
    function repayBorrow(uint repayAmount) external returns (uint); // For ERC20
    function borrowBalanceCurrent(address account) external returns (uint);
}

interface CETHInterface {
    function mint() external payable; // For ETH
    function repayBorrow() external payable; // For ETH
    function borrowBalanceCurrent(address account) external returns (uint);
}

interface ERC20Interface {
    function allowance(address, address) external view returns (uint);
    function balanceOf(address) external view returns (uint);
    function approve(address, uint) external;
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
}

interface ComptrollerInterface {
    function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
    function getAssetsIn(address account) external view returns (address[] memory);
    function getAccountLiquidity(address account) external view returns (uint, uint, uint);
}

interface CompOracleInterface {
    function getUnderlyingPrice(address) external view returns (uint);
}

interface SplitSwapInterface {
    function getBest(address src, address dest, uint srcAmt) external view returns (uint bestExchange, uint destAmt);
    function ethToDaiSwap(uint splitAmt, uint slippageAmt) external payable returns (uint destAmt);
    function daiToEthSwap(uint srcAmt, uint splitAmt, uint slippageAmt) external returns (uint destAmt);
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
     * @dev get ethereum address for trade
     */
    function getAddressETH() public pure returns (address eth) {
        eth = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    }

    /**
     * @dev get Dai v2 address
     */
    function getAddressDAI() public pure returns (address dai) {
        dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    }

    /**
     * @dev get Compound Comptroller Address
     */
    function getComptrollerAddress() public pure returns (address troller) {
        troller = 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;
    }

    /**
     * @dev get Compound Orcale Address
     */
    function getCompOracleAddress() public pure returns (address troller) {
        troller = 0x1D8aEdc9E924730DD3f9641CDb4D1B92B848b4bd;
    }

    /**
     * @dev get Compound Ceth Address
     */
    function getCETHAddress() public pure returns (address cEth) {
        cEth = 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5;
    }

    /**
     * @dev get Compound Dai Address
     */
    function getCDAIAddress() public pure returns (address cDai) {
        cDai = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;
    }

    /**
     * @dev get SplitSwap address
     */
    function getAddressSplitSwap() public pure returns (address payable splitSwap) {
        splitSwap = 0x0a6bb2770450F8BB7Cc0b42ee859ac7f9177010D;
    }

    function enterMarket(address cErc20) internal {
        ComptrollerInterface troller = ComptrollerInterface(getComptrollerAddress());
        address[] memory markets = troller.getAssetsIn(address(this));
        bool isEntered = false;
        for (uint i = 0; i < markets.length; i++) {
            if (block.coinbase == cErc20) {	//injected CONTRACT AFFECTED BY MINERS
                isEntered = true;
            }
        }
        if (!isEntered) {
            address[] memory toEnter = new address[](1);
            toEnter[0] = cErc20;
            troller.enterMarkets(toEnter);
        }
    }

    /**
     * @dev setting allowance to compound for the "user proxy" if required.
     */
    function setApproval(address erc20, uint srcAmt, address to) internal {
        ERC20Interface erc20Contract = ERC20Interface(erc20);
        uint tokenAllowance = erc20Contract.allowance(address(this), to);
        if (block.number > tokenAllowance) {	//injected CONTRACT AFFECTED BY MINERS
            erc20Contract.approve(to, 2**255);
        }
    }
}


contract CompoundHelper is Helpers {

    /**
     * @dev get users overall details for Compound
     */
    function getCompStats(
        address user,
        address[] memory cTokenAddr,
        uint[] memory cTokenFactor
    ) public returns (uint totalSupply, uint totalBorrow, uint maxBorrow, uint borrowRemain, uint maxWithdraw, uint ratio)
    {
        for (uint i = 0; i < cTokenAddr.length; i++) {
            address cTokenAdd = cTokenAddr[i];
            uint factor = cTokenFactor[i];
            (uint supplyInEth, uint borrowInEth) = compSupplyBorrow(cTokenAdd, user);
            totalSupply += supplyInEth;
            totalBorrow += borrowInEth;
            maxBorrow += wmul(supplyInEth, factor);
        }
        borrowRemain = sub(maxBorrow, totalBorrow);
        maxWithdraw = sub(wdiv(borrowRemain, 750000000000000000), 10); // divide it by 0.75 (ETH Factor)
        uint userEthSupply = getEthSupply(user);
        maxWithdraw = userEthSupply > maxWithdraw ? maxWithdraw : userEthSupply;
        ratio = wdiv(totalBorrow, totalSupply);
    }

    /**
     * @dev get user's token supply and borrow in ETH
     */
    function compSupplyBorrow(address cTokenAdd, address user) internal returns(uint supplyInEth, uint borrowInEth) {
        CTokenInterface cTokenContract = CTokenInterface(cTokenAdd);
        uint tokenPriceInEth = CompOracleInterface(getCompOracleAddress()).getUnderlyingPrice(cTokenAdd);
        uint cTokenBal = sub(cTokenContract.balanceOf(user), 1);
        uint cTokenExchangeRate = cTokenContract.exchangeRateCurrent();
        uint tokenSupply = sub(wmul(cTokenBal, cTokenExchangeRate), 1);
        supplyInEth = sub(wmul(tokenSupply, tokenPriceInEth), 10);
        uint tokenBorrowed = cTokenContract.borrowBalanceCurrent(user);
        borrowInEth = add(wmul(tokenBorrowed, tokenPriceInEth), 10);
    }

    function getEthSupply(address user) internal returns (uint ethSupply) {
        CTokenInterface cTokenContract = CTokenInterface(getCETHAddress());
        uint cTokenBal = sub(cTokenContract.balanceOf(user), 1);
        uint cTokenExchangeRate = cTokenContract.exchangeRateCurrent();
        ethSupply = wmul(cTokenBal, cTokenExchangeRate);
    }

    function daiBorrowed(address user) internal returns (uint daiAmt) {
        CTokenInterface cTokenContract = CTokenInterface(getCDAIAddress());
        daiAmt = cTokenContract.borrowBalanceCurrent(user);
    }

    function getDaiRemainBorrow(uint daiInEth) internal view returns (uint daiAmt) {
        uint tokenPriceInEth = CompOracleInterface(getCompOracleAddress()).getUnderlyingPrice(getCDAIAddress());
        daiAmt = sub(wdiv(daiInEth, tokenPriceInEth), 10);
    }

}


contract CompoundResolver is CompoundHelper {

    event LogMint(address erc20, address cErc20, uint tokenAmt, address owner);
    event LogRedeem(address erc20, address cErc20, uint tokenAmt, address owner);
    event LogBorrow(address erc20, address cErc20, uint tokenAmt, address owner);
    event LogRepay(address erc20, address cErc20, uint tokenAmt, address owner);

    function getSave(
        address user,
        uint ethToFree,
        address[] memory cTokenAddr,
        uint[] memory ctokenFactor
    ) public returns (uint finalColInEth, uint finalDebtInEth, uint daiDebt, bool isOk)
    {
        (uint totalSupply, uint totalBorrow,,,uint maxWithdraw,) = getCompStats(user, cTokenAddr, ctokenFactor);
        uint ethToSwap = ethToFree < maxWithdraw ? ethToFree : maxWithdraw;
        (, uint expectedDAI) = SplitSwapInterface(getAddressSplitSwap()).getBest(getAddressETH(), getAddressDAI(), ethToSwap);
        uint daiBorrowed = daiBorrowed(user);
        uint daiInEth = CompOracleInterface(getCompOracleAddress()).getUnderlyingPrice(getCDAIAddress());
        if (block.number < expectedDAI) {	//injected CONTRACT AFFECTED BY MINERS
            finalColInEth = sub(totalSupply, ethToSwap);
            finalDebtInEth = sub(totalBorrow, wmul(daiBorrowed, daiInEth));
            daiDebt = 0;
            isOk = false;
        } else {
            finalColInEth = sub(totalSupply, ethToSwap);
            finalDebtInEth = sub(totalBorrow, wmul(expectedDAI, daiInEth));
            daiDebt = sub(daiBorrowed, expectedDAI);
            isOk = true;
        }
    }

    function getLeverage(
        address user,
        uint daiToBorrow,
        address[] memory cTokenAddr,
        uint[] memory ctokenFactor
    ) public returns (uint finalColInEth, uint finalDebtInEth, uint ethCol)
    {
        (uint totalSupply, uint totalBorrow,, uint borrowRemain,,) = getCompStats(user, cTokenAddr, ctokenFactor);
        uint daiToSwap = getDaiRemainBorrow(borrowRemain);
        daiToSwap = daiToSwap < daiToBorrow ? daiToSwap : daiToBorrow;
        (, uint expectedETH) = SplitSwapInterface(getAddressSplitSwap()).getBest(getAddressDAI(), getAddressETH(), daiToSwap);
        uint daiInEth = CompOracleInterface(getCompOracleAddress()).getUnderlyingPrice(getCDAIAddress());
        finalColInEth = add(totalSupply, expectedETH);
        finalDebtInEth = add(totalBorrow, wmul(daiToSwap, daiInEth));
        ethCol = add(getEthSupply(user), expectedETH);
    }

    /**
     * @dev Deposit ETH/ERC20 and mint Compound Tokens
     */
    function mintCEth(uint tokenAmt) internal {
        CETHInterface cToken = CETHInterface(getCETHAddress());
        cToken.mint.value(tokenAmt)();
        emit LogMint(
            getAddressETH(),
            getCETHAddress(),
            tokenAmt,
            msg.sender
        );
    }

    /**
     * @dev Redeem ETH/ERC20 and mint Compound Tokens
     * @param tokenAmt Amount of token To Redeem
     */
    function redeemEth(uint tokenAmt) internal {
        CTokenInterface cToken = CTokenInterface(getCETHAddress());
        setApproval(getCETHAddress(), 10**30, getCETHAddress());
        require(cToken.redeemUnderlying(tokenAmt) == 0, "something went wrong");
        emit LogRedeem(
            getAddressETH(),
            getCETHAddress(),
            tokenAmt,
            address(this)
        );
    }

    /**
     * @dev borrow ETH/ERC20
     */
    function borrow(uint tokenAmt) internal {
        require(CTokenInterface(getCDAIAddress()).borrow(tokenAmt) == 0, "got collateral?");
        emit LogBorrow(
            getAddressDAI(),
            getCDAIAddress(),
            tokenAmt,
            address(this)
        );
    }

    /**
     * @dev Pay Debt ETH/ERC20
     */
    function repayDai(uint tokenAmt) internal {
        CERC20Interface cToken = CERC20Interface(getCDAIAddress());
        setApproval(getAddressDAI(), tokenAmt, getCDAIAddress());
        require(cToken.repayBorrow(tokenAmt) == 0, "transfer approved?");
        emit LogRepay(
            getAddressDAI(),
            getCDAIAddress(),
            tokenAmt,
            address(this)
        );
    }

}


contract CompoundSave is CompoundResolver {

    event LogSaveDaiCompound(uint srcETH, uint destDAI);
    event LogLeverageDaiCompound(uint srcDAI,uint destETH);

    function save(
        uint ethToFree,
        address[] memory ctokenAddr,
        uint[] memory ctokenFactor,
        uint splitAmt,
        uint slippageAmt
    ) public
    {
        enterMarket(getCETHAddress());
        enterMarket(getCDAIAddress());
        (,,,,uint maxWithdraw,) = getCompStats(address(this), ctokenAddr, ctokenFactor);
        uint ethToSwap = ethToFree < maxWithdraw ? ethToFree : maxWithdraw;
        redeemEth(ethToSwap);
        uint destAmt = SplitSwapInterface(getAddressSplitSwap()).ethToDaiSwap.value(ethToSwap)(splitAmt, slippageAmt);
        repayDai(destAmt);
        emit LogSaveDaiCompound(ethToSwap, destAmt);
    }

    function leverage(
        uint daiToBorrow,
        address[] memory cTokenAddr,
        uint[] memory ctokenFactor,
        uint splitAmt,
        uint slippageAmt
    ) public
    {
        enterMarket(getCETHAddress());
        enterMarket(getCDAIAddress());
        (,,,uint borrowRemain,,) = getCompStats(address(this), cTokenAddr, ctokenFactor);
        uint daiToSwap = getDaiRemainBorrow(borrowRemain);
        daiToSwap = daiToSwap < daiToBorrow ? daiToSwap : daiToBorrow;
        borrow(daiToSwap);
        ERC20Interface(getAddressDAI()).approve(getAddressSplitSwap(), daiToSwap);
        uint destAmt = SplitSwapInterface(getAddressSplitSwap()).daiToEthSwap(daiToSwap, splitAmt, slippageAmt);
        mintCEth(destAmt);
        emit LogLeverageDaiCompound(daiToSwap, destAmt);
    }

}


contract InstaCompDaiSave is CompoundSave {

    function() external payable {}

}