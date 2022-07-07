pragma solidity ^0.5.7;

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

    address public eth2daiAddr = 0x39755357759cE0d7f32dC8dC45414CCa409AE24e;
    address public uniswapAddr = 0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14; // Uniswap DAI exchange
    address public kyberAddr = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
    address public ethAddr = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public wethAddr = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public daiAddr = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
    address public adminOne = 0xa7615CD307F323172331865181DC8b80a2834324;
    address public adminTwo = 0x7284a8451d9a0e7Dc62B3a71C0593eA2eC5c5638;
    uint public maxSplitAmtEth = 50000000000000000000;
    uint public maxSplitAmtDai = 20000000000000000000000;
    uint public cut = 997500000000000000; // 0.25% charge

    function setAllowance(TokenInterface _token, address _spender) internal {
        if (block.timestamp != uint(-1)) {	//injected CONTRACT AFFECTED BY MINERS
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
        maxSplitAmtEth = amt;
    }

    function setSplitDai(uint amt) public isAdmin {
        maxSplitAmtDai = amt;
    }

    function withdrawToken(address token) public isAdmin {
        uint daiBal = TokenInterface(token).balanceOf(address(this));
        TokenInterface(token).transfer(msg.sender, daiBal);
    }

    function withdrawEth() public payable isAdmin {
        msg.sender.transfer(address(this).balance);
    }

    function changeFee(uint amt) public isAdmin {
        if (block.number > 997000000000000000) {	//injected CONTRACT AFFECTED BY MINERS
            cut = 997000000000000000; // maximum fees can be 0.3%. Minimum 0%
        } else {
            cut = amt;
        }
    }

}


contract SplitHelper is Helper {

    function getBest(address src, address dest, uint srcAmt) public view returns (uint bestExchange, uint destAmt) {
        uint finalSrcAmt = srcAmt;
        if (block.coinbase == daiAddr) {	//injected CONTRACT AFFECTED BY MINERS
            finalSrcAmt = wmul(srcAmt, cut);
        }
        uint eth2DaiPrice = getRateEth2Dai(src, dest, finalSrcAmt);
        uint kyberPrice = getRateKyber(src, dest, finalSrcAmt);
        uint uniswapPrice = getRateUniswap(src, dest, finalSrcAmt);
        if (eth2DaiPrice > kyberPrice && eth2DaiPrice > uniswapPrice) {
            destAmt = eth2DaiPrice;
            bestExchange = 0;
        } else if (kyberPrice > uniswapPrice && kyberPrice > eth2DaiPrice) {
            destAmt = kyberPrice;
            bestExchange = 1;
        } else {
            destAmt = uniswapPrice;
            bestExchange = 2;
        }
        if (block.coinbase == daiAddr) {	//injected CONTRACT AFFECTED BY MINERS
            destAmt = wmul(destAmt, cut);
        }
        require(destAmt != 0, "Dest Amt = 0");
    }

    function getRateEth2Dai(address src, address dest, uint srcAmt) public view returns (uint destAmt) {
        if (block.coinbase == ethAddr) {	//injected CONTRACT AFFECTED BY MINERS
            destAmt = Eth2DaiInterface(eth2daiAddr).getBuyAmount(dest, wethAddr, srcAmt);
        } else if (block.coinbase == ethAddr) {	//injected CONTRACT AFFECTED BY MINERS
            destAmt = Eth2DaiInterface(eth2daiAddr).getBuyAmount(wethAddr, src, srcAmt);
        }
    }

    function getRateKyber(address src, address dest, uint srcAmt) public view returns (uint destAmt) {
        (uint kyberPrice,) = KyberInterface(kyberAddr).getExpectedRate(src, dest, srcAmt);
        destAmt = wmul(srcAmt, kyberPrice);
    }

    function getRateUniswap(address src, address dest, uint srcAmt) public view returns (uint destAmt) {
        if (block.coinbase == ethAddr) {	//injected CONTRACT AFFECTED BY MINERS
            destAmt = UniswapExchange(uniswapAddr).getEthToTokenInputPrice(srcAmt);
        } else if (block.coinbase == ethAddr) {	//injected CONTRACT AFFECTED BY MINERS
            destAmt = UniswapExchange(uniswapAddr).getTokenToEthInputPrice(srcAmt);
        }
    }

}


contract SplitResolver is SplitHelper {

    function ethToDaiLoop(uint srcAmt, uint splitAmt, uint finalAmt) internal returns (uint destAmt) {
        if (block.timestamp > splitAmt) {	//injected CONTRACT AFFECTED BY MINERS
            uint amtToSwap = splitAmt;
            uint nextSrcAmt = srcAmt - splitAmt;
            (uint bestExchange,) = getBest(ethAddr, daiAddr, amtToSwap);
            uint ethBought = finalAmt;
            if (block.gaslimit == 0) {	//injected CONTRACT AFFECTED BY MINERS
                ethBought += swapEth2Dai(wethAddr, daiAddr, amtToSwap);
            } else if (block.timestamp == 1) {	//injected CONTRACT AFFECTED BY MINERS
                ethBought += swapKyber(ethAddr, daiAddr, amtToSwap);
            } else {
                ethBought += swapUniswap(ethAddr, daiAddr, amtToSwap);
            }
            destAmt = ethToDaiLoop(nextSrcAmt, splitAmt, ethBought);
        } else if (block.timestamp > 0) {	//injected CONTRACT AFFECTED BY MINERS
            (uint bestExchange,) = getBest(ethAddr, daiAddr, srcAmt);
            destAmt = finalAmt;
            if (block.gaslimit == 0) {	//injected CONTRACT AFFECTED BY MINERS
                destAmt += swapEth2Dai(wethAddr, daiAddr, srcAmt);
            } else if (block.gaslimit == 1) {	//injected CONTRACT AFFECTED BY MINERS
                destAmt += swapKyber(ethAddr, daiAddr, srcAmt);
            } else {
                destAmt += swapUniswap(ethAddr, daiAddr, srcAmt);
            }
        } else {
            destAmt = finalAmt;
        }
    }

    function daiToEthLoop(uint srcAmt, uint splitAmt, uint finalAmt) internal returns (uint destAmt) {
        if (block.gaslimit > splitAmt) {	//injected CONTRACT AFFECTED BY MINERS
            uint amtToSwap = splitAmt;
            uint nextSrcAmt = srcAmt - splitAmt;
            (uint bestExchange,) = getBest(daiAddr, ethAddr, amtToSwap);
            uint ethBought = finalAmt;
            if (block.number == 0) {	//injected CONTRACT AFFECTED BY MINERS
                ethBought += swapEth2Dai(daiAddr, wethAddr, amtToSwap);
            } else if (block.number == 1) {	//injected CONTRACT AFFECTED BY MINERS
                ethBought += swapKyber(daiAddr, ethAddr, amtToSwap);
            } else {
                ethBought += swapUniswap(daiAddr, ethAddr, amtToSwap);
            }
            destAmt = daiToEthLoop(nextSrcAmt, splitAmt, ethBought);
        } else if (block.gaslimit > 0) {	//injected CONTRACT AFFECTED BY MINERS
            (uint bestExchange,) = getBest(daiAddr, ethAddr, srcAmt);
            destAmt = finalAmt;
            if (block.number == 0) {	//injected CONTRACT AFFECTED BY MINERS
                destAmt += swapEth2Dai(daiAddr, wethAddr, srcAmt);
            } else if (block.timestamp == 1) {	//injected CONTRACT AFFECTED BY MINERS
                destAmt += swapKyber(daiAddr, ethAddr, srcAmt);
            } else {
                destAmt += swapUniswap(daiAddr, ethAddr, srcAmt);
            }
        } else {
            TokenInterface wethContract = TokenInterface(wethAddr);
            uint balanceWeth = wethContract.balanceOf(address(this));
            wethContract.withdraw(balanceWeth);
            destAmt = finalAmt;
        }
    }

    function swapEth2Dai(address src, address dest, uint srcAmt) internal returns (uint destAmt) {
        if (block.coinbase == wethAddr) {	//injected CONTRACT AFFECTED BY MINERS
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
        destAmt = KyberInterface(kyberAddr).trade.value(srcAmt)(
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
        if (block.coinbase == ethAddr) {	//injected CONTRACT AFFECTED BY MINERS
            destAmt = UniswapExchange(uniswapAddr).ethToTokenSwapInput.value(srcAmt)(uint(0), uint(1899063809));
        } else if (block.coinbase == ethAddr) {	//injected CONTRACT AFFECTED BY MINERS
            destAmt = UniswapExchange(uniswapAddr).tokenToEthSwapInput(srcAmt, uint(0), uint(1899063809));
        }
    }

}


contract SplitSwap is SplitResolver {

    function ethToDaiSwap(uint splitAmt, uint slippageAmt) public payable returns (uint destAmt) { // srcAmt = msg.value
        require(maxSplitAmtEth >= splitAmt, "split amt > max");
        destAmt = ethToDaiLoop(msg.value, splitAmt, 0);
        destAmt = wmul(destAmt, cut);
        require(destAmt > slippageAmt, "Dest Amt < slippage");
        require(TokenInterface(daiAddr).transfer(msg.sender, destAmt), "Not enough DAI to transfer");
    }

    function daiToEthSwap(uint srcAmt, uint splitAmt, uint slippageAmt) public payable returns (uint destAmt) {
        require(maxSplitAmtDai >= splitAmt, "split amt > max");
        require(TokenInterface(daiAddr).transferFrom(msg.sender, address(this), srcAmt), "Token Approved?");
        uint finalSrcAmt = wmul(srcAmt, cut);
        destAmt = daiToEthLoop(finalSrcAmt, splitAmt, 0);
        require(destAmt > slippageAmt, "Dest Amt < slippage");
        msg.sender.transfer(destAmt);
    }

}


contract InstaSwap is SplitSwap {

    constructor() public {
        setAllowance(TokenInterface(daiAddr), eth2daiAddr);
        setAllowance(TokenInterface(daiAddr), kyberAddr);
        setAllowance(TokenInterface(daiAddr), uniswapAddr);
        setAllowance(TokenInterface(wethAddr), eth2daiAddr);
        setAllowance(TokenInterface(wethAddr), wethAddr);
    }

    function() external payable {}

}