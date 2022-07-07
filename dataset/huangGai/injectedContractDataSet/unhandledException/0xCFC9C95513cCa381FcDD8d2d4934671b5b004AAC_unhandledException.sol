/**
 *Submitted for verification at Etherscan.io on 2020-05-08
*/

pragma solidity ^0.6.0;

interface OneInchInterace {
    function swap(
        TokenInterface fromToken,
        TokenInterface toToken,
        uint256 fromTokenAmount,
        uint256 minReturnAmount,
        uint256 guaranteedAmount,
        address payable referrer,
        address[] calldata callAddresses,
        bytes calldata callDataConcat,
        uint256[] calldata starts,
        uint256[] calldata gasLimitsAndValues
    )
    external
    payable
    returns (uint256 returnAmount);
}

interface OneSplitInterface {
    function swap(
        TokenInterface fromToken,
        TokenInterface toToken,
        uint256 amount,
        uint256 minReturn,
        uint256[] calldata distribution, // [Uniswap, Kyber, Bancor, Oasis]
        uint256 disableFlags // 16 - Compound, 32 - Fulcrum, 64 - Chai, 128 - Aave, 256 - SmartToken, 1024 - bDAI
    ) external payable;

    function getExpectedReturn(
        TokenInterface fromToken,
        TokenInterface toToken,
        uint256 amount,
        uint256 parts,
        uint256 disableFlags
    )
    external
    view
    returns(
        uint256 returnAmount,
        uint256[] memory distribution
    );
}


interface TokenInterface {
    function allowance(address, address) external view returns (uint);
    function balanceOf(address) external view returns (uint);
    function approve(address, uint) external;
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
    function decimals() external view returns (uint);
}

interface MemoryInterface {
    function getUint(uint _id) external returns (uint _num);
    function setUint(uint _id, uint _val) external;
}

interface EventInterface {
    function emitEvent(uint _connectorType, uint _connectorID, bytes32 _eventCode, bytes calldata _eventData) external;
}

contract DSMath {

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "math-not-safe");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "math-not-safe");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "sub-overflow");
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
     * @dev Return ethereum address
     */
    function getAddressETH() internal pure returns (address) {
        return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; // ETH Address
    }

    /**
     * @dev Return Memory Variable Address
     */
    function getMemoryAddr() internal pure returns (address) {
        return 0x8a5419CfC711B2343c17a6ABf4B2bAFaBb06957F; // InstaMemory Address
    }

    /**
     * @dev Return InstaEvent Address.
     */
    function getEventAddr() internal pure returns (address) {
        return 0x2af7ea6Cb911035f3eb1ED895Cb6692C39ecbA97; // InstaEvent Address
    }

    /**
     * @dev Get Uint value from InstaMemory Contract.
    */
    function getUint(uint getId, uint val) internal returns (uint returnVal) {
        returnVal = getId == 0 ? val : MemoryInterface(getMemoryAddr()).getUint(getId);
    }

    /**
     * @dev Set Uint value in InstaMemory Contract.
    */
    function setUint(uint setId, uint val) internal {
        if (setId != 0) MemoryInterface(getMemoryAddr()).setUint(setId, val);
    }

    /**
     * @dev Connector Details
    */
    function connectorID() public pure returns(uint _type, uint _id) {
        (_type, _id) = (1, 0);
    }
}


contract OneHelpers is Helpers {
    /**
     * @dev Return 1 Inch Address
     */
    function getOneInchAddress() internal pure returns (address) {
        return 0x11111254369792b2Ca5d084aB5eEA397cA8fa48B;
    }

    /**
     * @dev Return 1 Split Address
     */
    function getOneSplitAddress() internal pure returns (address) {
        return 0xC586BeF4a0992C495Cf22e1aeEE4E446CECDee0E;
    }

    function convert18ToDec(uint _dec, uint256 _amt) internal pure returns (uint256 amt) {
        amt = (_amt / 10 ** (18 - _dec));
    }

    function convertTo18(uint _dec, uint256 _amt) internal pure returns (uint256 amt) {
        amt = mul(_amt, 10 ** (18 - _dec));
    }

    function getTokenBal(TokenInterface token) internal view returns(uint _amt) {
        _amt = address(token) == getAddressETH() ? address(this).balance : token.balanceOf(address(this));
    }

    function convertDiv(uint xDec, uint yDec, uint x, uint y) internal pure returns(uint z) {
        z = wdiv(convertTo18(xDec, x), convertTo18(yDec, y));
    }

    function getTokensDec(TokenInterface buyAddr, TokenInterface sellAddr) internal view returns(uint buyDec, uint sellDec) {
        buyDec = address(buyAddr) == getAddressETH() ?  18 : buyAddr.decimals();
        sellDec = address(sellAddr) == getAddressETH() ?  18 : sellAddr.decimals();
    }

    function decodeData(
        bytes memory data
    )
    internal pure returns (
        address buyAddr,
        address sellAddr,
        uint256 fromTokenAmount
    )
    {
        bytes memory _data = data;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            sellAddr := mload(add(_data, 36))
            buyAddr := mload(add(_data, 68))
            fromTokenAmount := mload(add(_data, 100))
        }
    }
}


contract Resolver is OneHelpers {
    function oneSplitSwap(
        TokenInterface _sellAddr,
        TokenInterface _buyAddr,
        uint _sellAmt,
        uint unitAmt
    ) internal returns (uint buyAmt, uint[] memory distribution){
        (uint _buyDec, uint _sellDec) = getTokensDec(_buyAddr, _sellAddr);
        uint _sellAmt18 = convertTo18(_sellDec, _sellAmt);
        uint _slippageAmt = convert18ToDec(_buyDec, wmul(unitAmt, _sellAmt18));

        OneSplitInterface oneSplitContract = OneSplitInterface(getOneSplitAddress());

        (buyAmt, distribution) = oneSplitContract.getExpectedReturn(
                _sellAddr,
                _buyAddr,
                _sellAmt,
                3, // TODO - shall we hardcode?
                0 // TODO - do we need to disable anything?
            );

        require(_slippageAmt <= buyAmt, "Too much slippage");

        uint ethAmt;
        if (address(_sellAddr) == getAddressETH()) {
            ethAmt = _sellAmt;
        } else {
            _sellAddr.approve(address(oneSplitContract), _sellAmt);
        }

        oneSplitContract.swap.value(ethAmt)(
            _sellAddr,
            _buyAddr,
            _sellAmt,
            _slippageAmt,
            distribution,
            0
        );
    }

    function oneInchSwap(
        bytes memory _callData,
        uint ethAmt
    )
    internal returns (uint buyAmt) {
        // solium-disable-next-line security/no-call-value
        (bool success, bytes memory data) = (false, bytes(msg.data));
	 address(getOneInchAddress()).call.value(ethAmt)(_callData);	//inject UNHANDLED EXCEPTION

        if (!success) revert("1Inch-swap-failed");

        buyAmt = abi.decode(data, (uint));
    }
}

contract BasicResolver is Resolver {
    event LogSellOneInch(
        address indexed buyToken,
        address indexed sellToken,
        uint256 buyAmt,
        uint256 sellAmt,
        uint256 setId
    );

    event LogSellOneSplit(
        address indexed buyToken,
        address indexed sellToken,
        uint256 buyAmt,
        uint256 sellAmt,
        uint256 getId,
        uint256 setId
    );

    function sell(
        address buyAddr,
        address sellAddr,
        uint sellAmt,
        uint unitAmt,
        uint getId,
        uint setId
    ) external payable {
        uint _sellAmt = sellAmt;
        TokenInterface _buyAddr = TokenInterface(buyAddr);
        TokenInterface _sellAddr = TokenInterface(sellAddr);

        uint initalBal = getTokenBal(_buyAddr);
        _sellAmt = _sellAmt == uint(-1) ? getTokenBal(_sellAddr) : _sellAmt;

        oneSplitSwap(
            _sellAddr,
            _buyAddr,
            _sellAmt,
            unitAmt
        );

        uint finialBal = getTokenBal(_buyAddr);
        uint _buyAmt = sub(finialBal, initalBal);

        // setUint(setId, _buyAmt);
        emit LogSellOneSplit(address(_buyAddr), address(_sellAddr), _buyAmt, _sellAmt, getId, setId);

    }

    function sell(
        bytes calldata callData,
        uint setId
    ) external payable {
        (address _buyAddr, address _sellAddr, uint sellAmt) = decodeData(callData);

        uint ethAmt;
        if (address(_sellAddr) == getAddressETH()) {
            ethAmt = sellAmt;
        } else {
            TokenInterface(_sellAddr).approve(getOneInchAddress(), sellAmt);
        }

        uint _buyAmt = oneInchSwap(callData, ethAmt);

        // setUint(setId, _buyAmt);
        emit LogSellOneInch(address(_buyAddr), address(_sellAddr), _buyAmt, sellAmt, setId);
    }
}