/**
 *Submitted for verification at Etherscan.io on 2020-02-09
*/

pragma solidity ^0.5.8;

interface TokenInterface {
    function allowance(address, address) external view returns (uint);
    function balanceOf(address) external view returns (uint);
    function approve(address, uint) external;
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
    function deposit() external payable;
    function withdraw(uint) external;
}

interface UniswapExchange {
    function getEthToTokenInputPrice(uint ethSold) external view returns (uint tokenBought);
    function getTokenToEthInputPrice(uint tokenSold) external view returns (uint ethBought);
    function ethToTokenSwapInput(uint minTokens, uint deadline) external payable returns (uint tokenBought);
    function tokenToEthSwapInput(uint tokenSold, uint minEth, uint deadline) external returns (uint ethBought);
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

interface Eth2DaiInterface {
    function getBuyAmount(address dest, address src, uint srcAmt) external view returns(uint);
	function getPayAmount(address src, address dest, uint destAmt) external view returns (uint);
	function sellAllAmount(
        address src,
        uint srcAmt,
        address dest,
        uint minDest
    ) external returns (uint destAmt);
	function buyAllAmount(
        address dest,
        uint destAmt,
        address src,
        uint maxSrc
    ) external returns (uint srcAmt);
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

}


contract Helper is DSMath {

    address public eth2daiAddr = 0x794e6e91555438aFc3ccF1c5076A74F42133d08D;
    address public uniswapAddr = 0x2a1530C4C41db0B0b2bB646CB5Eb1A67b7158667; // Uniswap DAI exchange
    address public kyberAddr = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
    address public ethAddr = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public wethAddr = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal daiAddr = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public adminOne = 0xa7615CD307F323172331865181DC8b80a2834324;
    address public adminTwo = 0x7284a8451d9a0e7Dc62B3a71C0593eA2eC5c5638;
    uint internal maxSplitAmtEth = 60000000000000000000;
    uint internal maxSplitAmtDai = 20000000000000000000000;
    uint internal cut = 1000000000000000000; // 0% charge
    uint internal minDai = 200000000000000000000; // DAI < 200 swap with Kyber or Uniswap
    uint internal minEth = 1000000000000000000; // ETH < 1 swap with Kyber or Uniswap

    function setAllowance(TokenInterface _token, address _spender) internal {
        if (_token.allowance(address(this), _spender) != uint(-1)) {
            _token.approve(_spender, uint(-1));
        }
    }

    modifier isAdmin {
        require(msg.sender == adminOne || msg.sender == adminTwo, "Not an Admin");
        _;
    }

}


contract AdminStuffs is Helper {

    function setSplitEth(uint amt) public isAdmin {
        maxSplitAmtEth = amt;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setSplitDai(uint amt) public isAdmin {
        maxSplitAmtDai = amt;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function withdrawToken(address token) public isAdmin {
        uint daiBal = TokenInterface(token).balanceOf(address(this));
        TokenInterface(token).transfer(msg.sender, daiBal);
    }

    function withdrawEth() public payable isAdmin {
        msg.sender.transfer(address(this).balance);
    }

    function changeFee(uint amt) public isAdmin {
        if (amt < 997000000000000000) {
            cut = 997000000000000000; // maximum fees can be 0.3%. Minimum 0%	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        } else {
            cut = amt;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
    }

    function changeMinEth(uint amt) public isAdmin {
        minEth = amt;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function changeMinDai(uint amt) public isAdmin {
        minDai = amt;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

}


contract SplitHelper is AdminStuffs {

    function getBest(address src, address dest, uint srcAmt) public view returns (uint bestExchange, uint destAmt) {
        uint finalSrcAmt = srcAmt;
        if (src == daiAddr) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            finalSrcAmt = wmul(srcAmt, cut);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        uint eth2DaiPrice = getRateEth2Dai(src, dest, finalSrcAmt);
        uint kyberPrice = getRateKyber(src, dest, finalSrcAmt);
        uint uniswapPrice = getRateUniswap(src, dest, finalSrcAmt);
        if (eth2DaiPrice > kyberPrice && eth2DaiPrice > uniswapPrice) {
            destAmt = eth2DaiPrice;
            bestExchange = 0;
        } else if (kyberPrice > eth2DaiPrice && kyberPrice > uniswapPrice) {
            destAmt = kyberPrice;
            bestExchange = 1;
        } else {
            destAmt = uniswapPrice;
            bestExchange = 2;
        }
        if (dest == daiAddr) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            destAmt = wmul(destAmt, cut);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        require(destAmt != 0, "Dest Amt = 0");
    }

    function getBestUniswapKyber(address src, address dest, uint srcAmt) public view returns (uint bestExchange, uint destAmt) {
        uint finalSrcAmt = srcAmt;
        if (src == daiAddr) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            finalSrcAmt = wmul(srcAmt, cut);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        uint kyberPrice = getRateKyber(src, dest, finalSrcAmt);
        uint uniswapPrice = getRateUniswap(src, dest, finalSrcAmt);
        if (kyberPrice >= uniswapPrice) {
            destAmt = kyberPrice;
            bestExchange = 1;
        } else {
            destAmt = uniswapPrice;
            bestExchange = 2;
        }
        if (dest == daiAddr) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            destAmt = wmul(destAmt, cut);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        require(destAmt != 0, "Dest Amt = 0");
    }

    function getRateEth2Dai(address src, address dest, uint srcAmt) internal view returns (uint destAmt) {
        if (src == ethAddr) {
            destAmt = Eth2DaiInterface(eth2daiAddr).getBuyAmount(dest, wethAddr, srcAmt);
        } else if (dest == ethAddr) {
            destAmt = Eth2DaiInterface(eth2daiAddr).getBuyAmount(wethAddr, src, srcAmt);
        }
    }

    function getRateKyber(address src, address dest, uint srcAmt) internal view returns (uint destAmt) {
        (uint kyberPrice,) = KyberInterface(kyberAddr).getExpectedRate(src, dest, srcAmt);
        destAmt = wmul(srcAmt, kyberPrice);
    }

    function getRateUniswap(address src, address dest, uint srcAmt) internal view returns (uint destAmt) {
        if (src == ethAddr) {
            destAmt = UniswapExchange(uniswapAddr).getEthToTokenInputPrice(srcAmt);
        } else if (dest == ethAddr) {
            destAmt = UniswapExchange(uniswapAddr).getTokenToEthInputPrice(srcAmt);
        }
    }

}


contract SplitResolver is SplitHelper {

    event LogEthToDai(address user, uint srcAmt, uint destAmt);
    event LogDaiToEth(address user, uint srcAmt, uint destAmt);

    function swapEth2Dai(address src, address dest, uint srcAmt) internal returns (uint destAmt) {
        if (src == wethAddr) {
            TokenInterface(wethAddr).deposit.value(srcAmt)();
        }
        destAmt = Eth2DaiInterface(eth2daiAddr).sellAllAmount(
                src,
                srcAmt,
                dest,
                0
            );
    }

    function swapKyber(address src, address dest, uint srcAmt) internal returns (uint destAmt) {
        uint ethAmt = src == ethAddr ? srcAmt : 0;
        destAmt = KyberInterface(kyberAddr).trade.value(ethAmt)(
                src,
                srcAmt,
                dest,
                address(this),
                2**255,
                0,
                adminOne
            );
    }

    function swapUniswap(address src, address dest, uint srcAmt) internal returns (uint destAmt) {
        if (src == ethAddr) {
            destAmt = UniswapExchange(uniswapAddr).ethToTokenSwapInput.value(srcAmt)(1, block.timestamp + 1);
        } else if (dest == ethAddr) {
            destAmt = UniswapExchange(uniswapAddr).tokenToEthSwapInput(srcAmt, 1, block.timestamp + 1);
        }
    }

    function ethToDaiBestSwap(uint bestExchange, uint amtToSwap) internal returns (uint destAmt) {
        if (bestExchange == 0) {
            destAmt += swapEth2Dai(wethAddr, daiAddr, amtToSwap);
        } else if (bestExchange == 1) {
            destAmt += swapKyber(ethAddr, daiAddr, amtToSwap);
        } else {
            destAmt += swapUniswap(ethAddr, daiAddr, amtToSwap);
        }
    }

    function ethToDaiLoop(uint srcAmt, uint splitAmt, uint finalAmt) internal returns (uint destAmt) {
        if (srcAmt > splitAmt) {
            uint amtToSwap = splitAmt;
            uint nextSrcAmt = srcAmt - splitAmt;
            (uint bestExchange,) = getBest(ethAddr, daiAddr, amtToSwap);
            uint daiBought = finalAmt;
            daiBought += ethToDaiBestSwap(bestExchange, amtToSwap);
            destAmt = ethToDaiLoop(nextSrcAmt, splitAmt, daiBought);
        } else if (srcAmt > minEth) {
            (uint bestExchange,) = getBest(ethAddr, daiAddr, srcAmt);
            destAmt = finalAmt;
            destAmt += ethToDaiBestSwap(bestExchange, srcAmt);
        } else if (srcAmt > 0) {
            (uint bestExchange,) = getBestUniswapKyber(ethAddr, daiAddr, srcAmt);
            destAmt = finalAmt;
            destAmt += ethToDaiBestSwap(bestExchange, srcAmt);
        } else {
            destAmt = finalAmt;
        }
    }

    function daiToEthBestSwap(uint bestExchange, uint amtToSwap) internal returns (uint destAmt) {
        if (bestExchange == 0) {
            destAmt += swapEth2Dai(daiAddr, wethAddr, amtToSwap);
        } else if (bestExchange == 1) {
            destAmt += swapKyber(daiAddr, ethAddr, amtToSwap);
        } else {
            destAmt += swapUniswap(daiAddr, ethAddr, amtToSwap);
        }
    }

    function daiToEthLoop(uint srcAmt, uint splitAmt, uint finalAmt) internal returns (uint destAmt) {
        if (srcAmt > splitAmt) {
            uint amtToSwap = splitAmt;
            uint nextSrcAmt = srcAmt - splitAmt;
            (uint bestExchange,) = getBest(daiAddr, ethAddr, amtToSwap);
            uint ethBought = finalAmt;
            ethBought += daiToEthBestSwap(bestExchange, amtToSwap);
            destAmt = daiToEthLoop(nextSrcAmt, splitAmt, ethBought);
        } else if (srcAmt > minDai) {
            (uint bestExchange,) = getBest(daiAddr, ethAddr, srcAmt);
            destAmt = finalAmt;
            destAmt += daiToEthBestSwap(bestExchange, srcAmt);
        } else if (srcAmt > 0) {
            (uint bestExchange,) = getBestUniswapKyber(daiAddr, ethAddr, srcAmt);
            destAmt = finalAmt;
            destAmt += daiToEthBestSwap(bestExchange, srcAmt);
        } else {
            destAmt = finalAmt;
        }
    }

    function wethToEth() internal {
        TokenInterface wethContract = TokenInterface(wethAddr);
        uint balanceWeth = wethContract.balanceOf(address(this));
        if (balanceWeth > 0) {
            wethContract.withdraw(balanceWeth);
        }
    }

}


contract Swap is SplitResolver {

    function ethToDaiSwap(uint splitAmt, uint slippageAmt) public payable returns (uint destAmt) { // srcAmt = msg.value
        require(maxSplitAmtEth >= splitAmt, "split amt > max");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        destAmt = ethToDaiLoop(msg.value, splitAmt, 0);
        destAmt = wmul(destAmt, cut);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(destAmt > slippageAmt, "Dest Amt < slippage");
        require(TokenInterface(daiAddr).transfer(msg.sender, destAmt), "Not enough DAI to transfer");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit LogEthToDai(msg.sender, msg.value, destAmt);
    }

    function daiToEthSwap(uint srcAmt, uint splitAmt, uint slippageAmt) public returns (uint destAmt) {
        require(maxSplitAmtDai >= splitAmt, "split amt > max");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(TokenInterface(daiAddr).transferFrom(msg.sender, address(this), srcAmt), "Token Approved?");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint finalSrcAmt = wmul(srcAmt, cut);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        destAmt = daiToEthLoop(finalSrcAmt, splitAmt, 0);
        wethToEth();
        require(destAmt > slippageAmt, "Dest Amt < slippage");
        msg.sender.transfer(destAmt);
        emit LogDaiToEth(msg.sender, finalSrcAmt, destAmt);
    }

}


contract SplitSwap is Swap {

    constructor() public {
        setAllowance(TokenInterface(daiAddr), eth2daiAddr);
        setAllowance(TokenInterface(daiAddr), kyberAddr);
        setAllowance(TokenInterface(daiAddr), uniswapAddr);
        setAllowance(TokenInterface(wethAddr), eth2daiAddr);
        setAllowance(TokenInterface(wethAddr), wethAddr);
    }

    function() external payable {}

}