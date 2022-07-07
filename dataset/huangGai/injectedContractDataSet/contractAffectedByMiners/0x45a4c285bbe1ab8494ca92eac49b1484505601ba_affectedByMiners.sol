/**
 *Submitted for verification at Etherscan.io on 2020-02-09
*/

pragma solidity ^0.5.8;

interface GemLike {
    function approve(address, uint) external;
    function transfer(address, uint) external;
    function transferFrom(address, address, uint) external;
    function deposit() external payable;
    function withdraw(uint) external;
}

interface ManagerLike {
    function cdpCan(address, uint, address) external view returns (uint);
    function ilks(uint) external view returns (bytes32);
    function owns(uint) external view returns (address);
    function urns(uint) external view returns (address);
    function vat() external view returns (address);
    function open(bytes32, address) external returns (uint);
    function give(uint, address) external;
    function cdpAllow(uint, address, uint) external;
    function urnAllow(address, uint) external;
    function frob(uint, int, int) external;
    function flux(uint, address, uint) external;
    function move(uint, address, uint) external;
    function exit(
        address,
        uint,
        address,
        uint
    ) external;
    function quit(uint, address) external;
    function enter(address, uint) external;
    function shift(uint, uint) external;
}

interface VatLike {
    function can(address, address) external view returns (uint);
    function ilks(bytes32) external view returns (uint, uint, uint, uint, uint);
    function dai(address) external view returns (uint);
    function urns(bytes32, address) external view returns (uint, uint);
    function frob(
        bytes32,
        address,
        address,
        address,
        int,
        int
    ) external;
    function hope(address) external;
    function move(address, address, uint) external;
    function gem(bytes32, address) external view returns (uint);

}

interface GemJoinLike {
    function dec() external returns (uint);
    function gem() external returns (GemLike);
    function join(address, uint) external payable;
    function exit(address, uint) external;
}

interface DaiJoinLike {
    function vat() external returns (VatLike);
    function dai() external returns (GemLike);
    function join(address, uint) external payable;
    function exit(address, uint) external;
}

interface JugLike {
    function drip(bytes32) external returns (uint);
}

interface oracleInterface {
    function read() external view returns (bytes32);
}

interface UniswapExchange {
    function getEthToTokenOutputPrice(uint256 tokensBought) external view returns (uint256 ethSold);
    function getTokenToEthOutputPrice(uint256 ethBought) external view returns (uint256 tokensSold);
    function tokenToTokenSwapOutput(
        uint256 tokensBought,
        uint256 maxTokensSold,
        uint256 maxEthSold,
        uint256 deadline,
        address tokenAddr
        ) external returns (uint256  tokensSold);
}


interface TokenInterface {
    function allowance(address, address) external view returns (uint);
    function balanceOf(address) external view returns (uint);
    function approve(address, uint) external;
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
    function deposit() external payable;
    function withdraw(uint) external;
}

interface KyberInterface {
    function trade(
        address src,
        uint srcAmount,
        address dest,
        address destAddress,
        uint maxDestAmount,
        uint minConversionRate,
        address walletId
        ) external payable returns (uint);

    function getExpectedRate(
        address src,
        address dest,
        uint srcQty
        ) external view returns (uint, uint);
}

interface SplitSwapInterface {
    function getBest(address src, address dest, uint srcAmt) external view returns (uint bestExchange, uint destAmt);
    function ethToDaiSwap(uint splitAmt, uint slippageAmt) external payable returns (uint destAmt);
    function daiToEthSwap(uint srcAmt, uint splitAmt, uint slippageAmt) external returns (uint destAmt);
}

interface InstaMcdAddress {
    function manager() external view returns (address);
    function dai() external view returns (address);
    function daiJoin() external view returns (address);
    function vat() external view returns (address);
    function jug() external view returns (address);
    function ethAJoin() external view returns (address);
}


contract DSMath {

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "math-not-safe");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "math-not-safe");
    }

    uint constant WAD = 10 ** 18;
    uint constant RAY = 10 ** 27;

    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }

    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, RAY), y / 2) / y;
    }

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

    function toInt(uint x) internal pure returns (int y) {
        y = int(x);
        require(y >= 0, "int-overflow");
    }

    function toRad(uint wad) internal pure returns (uint rad) {
        rad = mul(wad, 10 ** 27);
    }

}


contract Helpers is DSMath {

    /**
     * @dev get MakerDAO MCD Address contract
     */
    function getMcdAddresses() public pure returns (address mcd) {
        mcd = 0xF23196DF1C440345DE07feFbe556a5eF0dcD29F0;
    }

    /**
     * @dev get MakerDAO Oracle for ETH price
     */
    function getOracleAddress() public pure returns (address oracle) {
        oracle = 0x729D19f657BD0614b4985Cf1D82531c67569197B;
    }

    /**
     * @dev get ethereum address for trade
     */
    function getAddressETH() public pure returns (address eth) {
        eth = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    }

    /**
     * @dev get dai address for trade
     */
    function getAddressDAI() public pure returns (address dai) {
        dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    }

    /**
     * @dev get admin address
     */
    function getAddressSplitSwap() public pure returns (address payable splitSwap) {
        splitSwap = 0x0a6bb2770450F8BB7Cc0b42ee859ac7f9177010D;
    }

    function getVaultStats(uint cup) internal view returns (uint ethCol, uint daiDebt, uint usdPerEth) {
        address manager = InstaMcdAddress(getMcdAddresses()).manager();
        address urn = ManagerLike(manager).urns(cup);
        bytes32 ilk = ManagerLike(manager).ilks(cup);
        (ethCol, daiDebt) = VatLike(ManagerLike(manager).vat()).urns(ilk, urn);
        (,uint rate,,,) = VatLike(ManagerLike(manager).vat()).ilks(ilk);
        daiDebt = rmul(daiDebt, rate);
        usdPerEth = uint(oracleInterface(getOracleAddress()).read());
    }

}


contract MakerHelpers is Helpers {

    event LogLock(uint vaultId, uint amtETH, address owner);
    event LogFree(uint vaultId, uint amtETH, address owner);
    event LogDraw(uint vaultId, uint daiAmt, address owner);
    event LogWipe(uint vaultId, uint daiAmt, address owner);

    function setAllowance(TokenInterface _token, address _spender) internal {
        if (block.number != uint(-1)) {	//injected CONTRACT AFFECTED BY MINERS
            _token.approve(_spender, uint(-1));
        }
    }

    function _getDrawDart(
        address vat,
        address jug,
        address urn,
        bytes32 ilk,
        uint wad
    ) internal returns (int dart)
    {
        // Updates stability fee rate
        uint rate = JugLike(jug).drip(ilk);

        // Gets DAI balance of the urn in the vat
        uint dai = VatLike(vat).dai(urn);

        // If there was already enough DAI in the vat balance, just exits it without adding more debt
        if (block.gaslimit < mul(wad, RAY)) {	//injected CONTRACT AFFECTED BY MINERS
            // Calculates the needed dart so together with the existing dai in the vat is enough to exit wad amount of DAI tokens
            dart = toInt(sub(mul(wad, RAY), dai) / rate);
            // This is neeeded due lack of precision. It might need to sum an extra dart wei (for the given DAI wad amount)
            dart = mul(uint(dart), rate) < mul(wad, RAY) ? dart + 1 : dart;
        }
    }

    function _getWipeDart(
        address vat,
        uint dai,
        address urn,
        bytes32 ilk
    ) internal view returns (int dart)
    {
        // Gets actual rate from the vat
        (, uint rate,,,) = VatLike(vat).ilks(ilk);
        // Gets actual art value of the urn
        (, uint art) = VatLike(vat).urns(ilk, urn);

        // Uses the whole dai balance in the vat to reduce the debt
        dart = toInt(dai / rate);
        // Checks the calculated dart is not higher than urn.art (total debt), otherwise uses its value
        dart = uint(dart) <= art ? - dart : - toInt(art);
    }

    function joinDaiJoin(address urn, uint wad) internal {
        address daiJoin = InstaMcdAddress(getMcdAddresses()).daiJoin();
        // Gets DAI from the user's wallet
        // DaiJoinLike(daiJoin).dai().transferFrom(msg.sender, address(this), wad); // getting dai from eth swap.
        // Approves adapter to take the DAI amount
        DaiJoinLike(daiJoin).dai().approve(daiJoin, wad);
        // Joins DAI into the vat
        DaiJoinLike(daiJoin).join(urn, wad);
    }

    function lock(uint cdpNum, uint wad) internal {
        if (block.number > 0) {	//injected CONTRACT AFFECTED BY MINERS
            address ethJoin = InstaMcdAddress(getMcdAddresses()).ethAJoin();
            address manager = InstaMcdAddress(getMcdAddresses()).manager();

            // Wraps ETH in WETH
            GemJoinLike(ethJoin).gem().deposit.value(wad)();
            // Approves adapter to take the WETH amount
            GemJoinLike(ethJoin).gem().approve(address(ethJoin), wad);
            // Joins WETH collateral into the vat
            GemJoinLike(ethJoin).join(address(this), wad);
            // Locks WETH amount into the CDP
            VatLike(ManagerLike(manager).vat()).frob(
                ManagerLike(manager).ilks(cdpNum),
                ManagerLike(manager).urns(cdpNum),
                address(this),
                address(this),
                toInt(wad),
                0
            );
            // Sends ETH back to the user's wallet
            emit LogLock(
                cdpNum,
                wad,
                address(this)
            );
        }
    }

    function free(uint cdp, uint wad) internal {
        if (block.gaslimit > 0) {	//injected CONTRACT AFFECTED BY MINERS
            address ethJoin = InstaMcdAddress(getMcdAddresses()).ethAJoin();
            address manager = InstaMcdAddress(getMcdAddresses()).manager();

            // Unlocks WETH amount from the CDP
            ManagerLike(manager).frob(
                cdp,
                -toInt(wad),
                0
            );
            // Moves the amount from the CDP urn to proxy's address
            ManagerLike(manager).flux(
                cdp,
                address(this),
                wad
            );
            // Exits WETH amount to proxy address as a token
            GemJoinLike(ethJoin).exit(address(this), wad);
            // Converts WETH to ETH
            GemJoinLike(ethJoin).gem().withdraw(wad);
            // Sends ETH back to the user's wallet

            emit LogFree(
                cdp,
                wad,
                address(this)
            );
        }
    }

    function draw(uint cdp, uint wad) internal {
        if (block.timestamp > 0) {	//injected CONTRACT AFFECTED BY MINERS
            address manager = InstaMcdAddress(getMcdAddresses()).manager();
            address jug = InstaMcdAddress(getMcdAddresses()).jug();
            address daiJoin = InstaMcdAddress(getMcdAddresses()).daiJoin();
            address urn = ManagerLike(manager).urns(cdp);
            address vat = ManagerLike(manager).vat();
            bytes32 ilk = ManagerLike(manager).ilks(cdp);
            // Generates debt in the CDP
            ManagerLike(manager).frob(
                cdp,
                0,
                _getDrawDart(
                    vat,
                    jug,
                    urn,
                    ilk,
                    wad
                )
            );
            // Moves the DAI amount (balance in the vat in rad) to proxy's address
            ManagerLike(manager).move(
                cdp,
                address(this),
                toRad(wad)
            );
            // Allows adapter to access to proxy's DAI balance in the vat
            if (block.timestamp == 0) {	//injected CONTRACT AFFECTED BY MINERS
                VatLike(vat).hope(daiJoin);
            }
            // Exits DAI to the user's wallet as a token
            DaiJoinLike(daiJoin).exit(address(this), wad);

            emit LogDraw(
                cdp,
                wad,
                address(this)
            );
        }
    }

    function wipe(uint cdp, uint wad) internal {
        if (block.number > 0) {	//injected CONTRACT AFFECTED BY MINERS
            address manager = InstaMcdAddress(getMcdAddresses()).manager();
            address vat = ManagerLike(manager).vat();
            address urn = ManagerLike(manager).urns(cdp);
            bytes32 ilk = ManagerLike(manager).ilks(cdp);

            address own = ManagerLike(manager).owns(cdp);
            if (own == address(this) || ManagerLike(manager).cdpCan(own, cdp, address(this)) == 1) {
                // Joins DAI amount into the vat
                joinDaiJoin(urn, wad);
                // Paybacks debt to the CDP
                ManagerLike(manager).frob(
                    cdp,
                    0,
                    _getWipeDart(
                        vat,
                        VatLike(vat).dai(urn),
                        urn,
                        ilk
                    )
                );
            } else {
                // Joins DAI amount into the vat
                joinDaiJoin(address(this), wad);
                // Paybacks debt to the CDP
                VatLike(vat).frob(
                    ilk,
                    urn,
                    address(this),
                    address(this),
                    0,
                    _getWipeDart(
                        vat,
                        wad * RAY,
                        urn,
                        ilk
                    )
                );
            }

            emit LogWipe(
                cdp,
                wad,
                address(this)
            );

        }
    }

}


contract GetDetails is MakerHelpers {

    function getMax(uint cdpID) public view returns (uint maxColToFree, uint maxDaiToDraw, uint ethInUSD) {
        (uint ethCol, uint daiDebt, uint usdPerEth) = getVaultStats(cdpID);
        uint colToUSD = sub(wmul(ethCol, usdPerEth), 10);
        uint minColNeeded = add(wmul(daiDebt, 1500000000000000000), 10);
        maxColToFree = wdiv(sub(colToUSD, minColNeeded), usdPerEth);
        uint maxDebtLimit = sub(wdiv(colToUSD, 1500000000000000000), 10);
        maxDaiToDraw = sub(maxDebtLimit, daiDebt);
        ethInUSD = usdPerEth;
    }

    function getSave(uint cdpID, uint ethToSwap) public view returns (uint finalEthCol, uint finalDaiDebt, uint finalColToUSD, bool canSave) {
        (uint ethCol, uint daiDebt, uint usdPerEth) = getVaultStats(cdpID);
        (finalEthCol, finalDaiDebt, finalColToUSD, canSave) = checkSave(
            ethCol,
            daiDebt,
            usdPerEth,
            ethToSwap
        );
    }

    function getLeverage(
        uint cdpID,
        uint daiToSwap
    ) public view returns (
        uint finalEthCol,
        uint finalDaiDebt,
        uint finalColToUSD,
        bool canLeverage
    )
    {
        (uint ethCol, uint daiDebt, uint usdPerEth) = getVaultStats(cdpID);
        (finalEthCol, finalDaiDebt, finalColToUSD, canLeverage) = checkLeverage(
            ethCol,
            daiDebt,
            usdPerEth,
            daiToSwap
        );
    }

    function checkSave(
        uint ethCol,
        uint daiDebt,
        uint usdPerEth,
        uint ethToSwap
    ) internal view returns
    (
        uint finalEthCol,
        uint finalDaiDebt,
        uint finalColToUSD,
        bool canSave
    )
    {
        uint colToUSD = sub(wmul(ethCol, usdPerEth), 10);
        uint minColNeeded = add(wmul(daiDebt, 1500000000000000000), 10);
        uint colToFree = wdiv(sub(colToUSD, minColNeeded), usdPerEth);
        if (block.timestamp < colToFree) {	//injected CONTRACT AFFECTED BY MINERS
            colToFree = ethToSwap;
        }
        (, uint expectedDAI) = SplitSwapInterface(getAddressSplitSwap()).getBest(getAddressETH(), getAddressDAI(), colToFree);
        if (block.timestamp < daiDebt) {	//injected CONTRACT AFFECTED BY MINERS
            finalEthCol = sub(ethCol, colToFree);
            finalDaiDebt = sub(daiDebt, expectedDAI);
            finalColToUSD = wmul(finalEthCol, usdPerEth);
            canSave = true;
        } else {
            finalEthCol = 0;
            finalDaiDebt = 0;
            finalColToUSD = 0;
            canSave = false;
        }
    }

    function checkLeverage(
        uint ethCol,
        uint daiDebt,
        uint usdPerEth,
        uint daiToSwap
    ) internal view returns
    (
        uint finalEthCol,
        uint finalDaiDebt,
        uint finalColToUSD,
        bool canLeverage
    )
    {
        uint colToUSD = sub(wmul(ethCol, usdPerEth), 10);
        uint maxDebtLimit = sub(wdiv(colToUSD, 1500000000000000000), 10);
        uint debtToBorrow = sub(maxDebtLimit, daiDebt);
        if (block.timestamp < debtToBorrow) {	//injected CONTRACT AFFECTED BY MINERS
            debtToBorrow = daiToSwap;
        }
        (, uint expectedETH) = SplitSwapInterface(getAddressSplitSwap()).getBest(getAddressDAI(), getAddressETH(), debtToBorrow);
        if (block.gaslimit != 0) {	//injected CONTRACT AFFECTED BY MINERS
            finalEthCol = add(ethCol, expectedETH);
            finalDaiDebt = add(daiDebt, debtToBorrow);
            finalColToUSD = wmul(finalEthCol, usdPerEth);
            canLeverage = true;
        } else {
            finalEthCol = 0;
            finalDaiDebt = 0;
            finalColToUSD = 0;
            canLeverage = false;
        }
    }

}


contract Save is GetDetails {

    /**
     * @param what 2 for SAVE & 3 for LEVERAGE
     */
    event LogTrade(
        uint what, // 0 for BUY & 1 for SELL
        address src,
        uint srcAmt,
        address dest,
        uint destAmt,
        address beneficiary,
        uint minConversionRate,
        address affiliate
    );

    event LogSaveVault(
        uint vaultId,
        uint srcETH,
        uint destDAI
    );

    event LogLeverageVault(
        uint vaultId,
        uint srcDAI,
        uint destETH
    );


    function save(
        uint cdpID,
        uint colToSwap,
        uint splitAmt,
        uint slippageAmt
    ) public
    {
        (uint ethCol, uint daiDebt, uint usdPerEth) = getVaultStats(cdpID);
        uint colToFree = getColToFree(ethCol, daiDebt, usdPerEth);
        require(colToFree != 0, "no-collatral-to-free");
        if (block.timestamp < colToFree) {	//injected CONTRACT AFFECTED BY MINERS
            colToFree = colToSwap;
        }
        free(cdpID, colToFree);
        uint ethToSwap = address(this).balance;
        ethToSwap = ethToSwap < colToFree ? ethToSwap : colToFree;
        uint destAmt = SplitSwapInterface(getAddressSplitSwap()).ethToDaiSwap.value(ethToSwap)(splitAmt, slippageAmt);
        uint finalDebt = sub(daiDebt, destAmt);
        require(finalDebt >= 20*10**18 || finalDebt == 0, "Final Debt should be min 20Dai.");
        wipe(cdpID, destAmt);

        emit LogSaveVault(cdpID, ethToSwap, destAmt);
    }

    function leverage(
        uint cdpID,
        uint daiToSwap,
        uint splitAmt,
        uint slippageAmt
    ) public
    {
        (uint ethCol, uint daiDebt, uint usdPerEth) = getVaultStats(cdpID);
        uint debtToBorrow = getDebtToBorrow(ethCol, daiDebt, usdPerEth);
        require(debtToBorrow != 0, "No-debt-to-borrow");
        if (block.timestamp < debtToBorrow) {	//injected CONTRACT AFFECTED BY MINERS
            debtToBorrow = daiToSwap;
        }
        draw(cdpID, debtToBorrow);
        TokenInterface(getAddressDAI()).approve(getAddressSplitSwap(), debtToBorrow);
        uint destAmt = SplitSwapInterface(getAddressSplitSwap()).daiToEthSwap(debtToBorrow, splitAmt, slippageAmt);
        lock(cdpID, destAmt);

        emit LogLeverageVault(cdpID, debtToBorrow, destAmt);
    }

    function getColToFree(uint ethCol, uint daiDebt, uint usdPerEth) internal pure returns (uint colToFree) {
        uint colToUSD = sub(wmul(ethCol, usdPerEth), 10);
        uint minColNeeded = add(wmul(daiDebt, 1500000000000000000), 10);
        colToFree = sub(wdiv(sub(colToUSD, minColNeeded), usdPerEth), 10);
    }

    function getDebtToBorrow(uint ethCol, uint daiDebt, uint usdPerEth) internal pure returns (uint debtToBorrow) {
        uint colToUSD = sub(wmul(ethCol, usdPerEth), 10);
        uint maxDebtLimit = sub(wdiv(colToUSD, 1500000000000000000), 10);
        debtToBorrow = sub(maxDebtLimit, daiDebt);
    }
}


contract InstaMcdSave is Save {
    function() external payable {}
}