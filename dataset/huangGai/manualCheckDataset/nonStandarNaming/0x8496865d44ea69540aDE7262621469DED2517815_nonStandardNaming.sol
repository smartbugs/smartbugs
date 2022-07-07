                                                                 

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface TokenInterface {
    function APPROVE44(address, uint256) external;	//inject NONSTANDARD NAMING
    function TRANSFER867(address, uint) external;	//inject NONSTANDARD NAMING
    function TRANSFERFROM416(address, address, uint) external;	//inject NONSTANDARD NAMING
    function DEPOSIT488() external payable;	//inject NONSTANDARD NAMING
    function WITHDRAW102(uint) external;	//inject NONSTANDARD NAMING
    function BALANCEOF737(address) external view returns (uint);	//inject NONSTANDARD NAMING
    function DECIMALS200() external view returns (uint);	//inject NONSTANDARD NAMING
}

interface MemoryInterface {
    function GETUINT774(uint id) external returns (uint num);	//inject NONSTANDARD NAMING
    function SETUINT548(uint id, uint val) external;	//inject NONSTANDARD NAMING
}

interface EventInterface {
    function EMITEVENT565(uint connectorType, uint connectorID, bytes32 eventCode, bytes calldata eventData) external;	//inject NONSTANDARD NAMING
}

contract Stores {

                                             
  function GETETHADDR620() internal pure returns (address) {	//inject NONSTANDARD NAMING
    return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; // ETH Address
  }

                                                    
  function GETMEMORYADDR192() internal pure returns (address) {	//inject NONSTANDARD NAMING
    return 0x8a5419CfC711B2343c17a6ABf4B2bAFaBb06957F; // InstaMemory Address
  }

                                                
  function GETEVENTADDR446() internal pure returns (address) {	//inject NONSTANDARD NAMING
    return 0x2af7ea6Cb911035f3eb1ED895Cb6692C39ecbA97; // InstaEvent Address
  }

                                                               
  function GETUINT774(uint getId, uint val) internal returns (uint returnVal) {	//inject NONSTANDARD NAMING
    returnVal = getId == 0 ? val : MemoryInterface(GETMEMORYADDR192()).GETUINT774(getId);
  }

                                                           
  function SETUINT548(uint setId, uint val) virtual internal {	//inject NONSTANDARD NAMING
    if (setId != 0) MemoryInterface(GETMEMORYADDR192()).SETUINT548(setId, val);
  }

                                                
  function EMITEVENT565(bytes32 eventCode, bytes memory eventData) virtual internal {	//inject NONSTANDARD NAMING
    (uint model, uint id) = CONNECTORID65();
    EventInterface(GETEVENTADDR446()).EMITEVENT565(model, id, eventCode, eventData);
  }

                                      
  function CONNECTORID65() public view returns(uint model, uint id) {	//inject NONSTANDARD NAMING
    (model, id) = (1, 38);
  }

}


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                                    
    function ADD435(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB700(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB700(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB700(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL278(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV204(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV204(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV204(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD700(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD700(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD700(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract DSMath {
  uint constant wad945 = 10 ** 18;	//inject NONSTANDARD NAMING
  uint constant ray928 = 10 ** 27;	//inject NONSTANDARD NAMING

  function ADD435(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
    z = SafeMath.ADD435(x, y);
  }

  function SUB700(uint x, uint y) internal virtual pure returns (uint z) {	//inject NONSTANDARD NAMING
    z = SafeMath.SUB700(x, y);
  }

  function MUL278(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
    z = SafeMath.MUL278(x, y);
  }

  function DIV204(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
    z = SafeMath.DIV204(x, y);
  }

  function WMUL242(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
    z = SafeMath.ADD435(SafeMath.MUL278(x, y), wad945 / 2) / wad945;
  }

  function WDIV461(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
    z = SafeMath.ADD435(SafeMath.MUL278(x, wad945), y / 2) / y;
  }

  function RDIV516(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
    z = SafeMath.ADD435(SafeMath.MUL278(x, ray928), y / 2) / y;
  }

  function RMUL757(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
    z = SafeMath.ADD435(SafeMath.MUL278(x, y), ray928 / 2) / ray928;
  }

}

interface OneInchInterace {
    function SWAP155(	//inject NONSTANDARD NAMING
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

interface OneProtoInterface {
    function SWAPWITHREFERRAL361(	//inject NONSTANDARD NAMING
        TokenInterface fromToken,
        TokenInterface destToken,
        uint256 amount,
        uint256 minReturn,
        uint256[] calldata distribution,
        uint256 flags, // See contants in IOneSplit.sol
        address referral,
        uint256 feePercent
    ) external payable returns(uint256);

    function SWAPWITHREFERRALMULTI690(	//inject NONSTANDARD NAMING
        TokenInterface[] calldata tokens,
        uint256 amount,
        uint256 minReturn,
        uint256[] calldata distribution,
        uint256[] calldata flags,
        address referral,
        uint256 feePercent
    ) external payable returns(uint256 returnAmount);

    function GETEXPECTEDRETURN579(	//inject NONSTANDARD NAMING
        TokenInterface fromToken,
        TokenInterface destToken,
        uint256 amount,
        uint256 parts,
        uint256 flags // See constants in IOneSplit.sol
    )
    external
    view
    returns(
        uint256 returnAmount,
        uint256[] memory distribution
    );
}

interface OneProtoMappingInterface {
    function ONEPROTOADDRESS398() external view returns(address);	//inject NONSTANDARD NAMING
}


contract OneHelpers is Stores, DSMath {

                                                         
    function GETONEPROTOMAPPINGADDRESS394() internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return 0x8d0287AFa7755BB5f2eFe686AA8d4F0A7BC4AE7F;
    }

                                                 
    function GETONEPROTOADDRESS431() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return payable(OneProtoMappingInterface(GETONEPROTOMAPPINGADDRESS394()).ONEPROTOADDRESS398());
    }

                                                 
    function GETONEINCHADDRESS518() internal pure returns (address) {	//inject NONSTANDARD NAMING
        return 0x11111254369792b2Ca5d084aB5eEA397cA8fa48B;
    }

                                                            
    function GETONEINCHTOKENTAKER586() internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return 0xE4C9194962532fEB467DCe8b3d42419641c6eD2E;
    }

                                                          
    function GETONEINCHSIG889() internal pure returns (bytes4) {	//inject NONSTANDARD NAMING
        return 0xf88309d7;
    }

    function GETREFERRALADDR889() internal pure returns (address) {	//inject NONSTANDARD NAMING
        return 0xa7615CD307F323172331865181DC8b80a2834324;
    }

    function CONVERT18TODEC395(uint _dec, uint256 _amt) internal pure returns (uint256 amt) {	//inject NONSTANDARD NAMING
        amt = (_amt / 10 ** (18 - _dec));
    }

    function CONVERTTO18179(uint _dec, uint256 _amt) internal pure returns (uint256 amt) {	//inject NONSTANDARD NAMING
        amt = MUL278(_amt, 10 ** (18 - _dec));
    }

    function GETTOKENBAL438(TokenInterface token) internal view returns(uint _amt) {	//inject NONSTANDARD NAMING
        _amt = address(token) == GETETHADDR620() ? address(this).balance : token.BALANCEOF737(address(this));
    }

    function GETTOKENSDEC172(TokenInterface buyAddr, TokenInterface sellAddr) internal view returns(uint buyDec, uint sellDec) {	//inject NONSTANDARD NAMING
        buyDec = address(buyAddr) == GETETHADDR620() ?  18 : buyAddr.DECIMALS200();
        sellDec = address(sellAddr) == GETETHADDR620() ?  18 : sellAddr.DECIMALS200();
    }

    function GETSLIPPAGEAMT247(	//inject NONSTANDARD NAMING
        TokenInterface _buyAddr,
        TokenInterface _sellAddr,
        uint _sellAmt,
        uint unitAmt
    ) internal view returns(uint _slippageAmt) {
        (uint _buyDec, uint _sellDec) = GETTOKENSDEC172(_buyAddr, _sellAddr);
        uint _sellAmt18 = CONVERTTO18179(_sellDec, _sellAmt);
        _slippageAmt = CONVERT18TODEC395(_buyDec, WMUL242(unitAmt, _sellAmt18));
    }

    function CONVERTTOTOKENINTERFACE157(address[] memory tokens) internal pure returns(TokenInterface[] memory) {	//inject NONSTANDARD NAMING
        TokenInterface[] memory _tokens = new TokenInterface[](tokens.length);
        for (uint i = 0; i < tokens.length; i++) {
            _tokens[i] = TokenInterface(tokens[i]);
        }
        return _tokens;
    }
}


contract OneProtoResolver is OneHelpers {
    struct OneProtoData {
        TokenInterface sellToken;
        TokenInterface buyToken;
        uint _sellAmt;
        uint _buyAmt;
        uint unitAmt;
        uint[] distribution;
        uint disableDexes;
    }

    function ONEPROTOSWAP794(	//inject NONSTANDARD NAMING
        OneProtoInterface oneProtoContract,
        OneProtoData memory oneProtoData
    ) internal returns (uint buyAmt) {
        TokenInterface _sellAddr = oneProtoData.sellToken;
        TokenInterface _buyAddr = oneProtoData.buyToken;
        uint _sellAmt = oneProtoData._sellAmt;

        uint _slippageAmt = GETSLIPPAGEAMT247(_buyAddr, _sellAddr, _sellAmt, oneProtoData.unitAmt);

        uint ethAmt;
        if (address(_sellAddr) == GETETHADDR620()) {
            ethAmt = _sellAmt;
        } else {
            _sellAddr.APPROVE44(address(oneProtoContract), _sellAmt);
        }


        uint initalBal = GETTOKENBAL438(_buyAddr);
        oneProtoContract.SWAPWITHREFERRAL361.value(ethAmt)(
            _sellAddr,
            _buyAddr,
            _sellAmt,
            _slippageAmt,
            oneProtoData.distribution,
            oneProtoData.disableDexes,
            GETREFERRALADDR889(),
            0
        );
        uint finalBal = GETTOKENBAL438(_buyAddr);

        buyAmt = SUB700(finalBal, initalBal);

        require(_slippageAmt <= buyAmt, "Too much slippage");
    }

    struct OneProtoMultiData {
        address[] tokens;
        TokenInterface sellToken;
        TokenInterface buyToken;
        uint _sellAmt;
        uint _buyAmt;
        uint unitAmt;
        uint[] distribution;
        uint[] disableDexes;
    }

    function ONEPROTOSWAPMULTI285(OneProtoMultiData memory oneProtoData) internal returns (uint buyAmt) {	//inject NONSTANDARD NAMING
        TokenInterface _sellAddr = oneProtoData.sellToken;
        TokenInterface _buyAddr = oneProtoData.buyToken;
        uint _sellAmt = oneProtoData._sellAmt;
        uint _slippageAmt = GETSLIPPAGEAMT247(_buyAddr, _sellAddr, _sellAmt, oneProtoData.unitAmt);

        OneProtoInterface oneSplitContract = OneProtoInterface(GETONEPROTOADDRESS431());
        uint ethAmt;
        if (address(_sellAddr) == GETETHADDR620()) {
            ethAmt = _sellAmt;
        } else {
            _sellAddr.APPROVE44(address(oneSplitContract), _sellAmt);
        }

        uint initalBal = GETTOKENBAL438(_buyAddr);
        oneSplitContract.SWAPWITHREFERRALMULTI690.value(ethAmt)(
            CONVERTTOTOKENINTERFACE157(oneProtoData.tokens),
            _sellAmt,
            _slippageAmt,
            oneProtoData.distribution,
            oneProtoData.disableDexes,
            GETREFERRALADDR889(),
            0
        );
        uint finalBal = GETTOKENBAL438(_buyAddr);

        buyAmt = SUB700(finalBal, initalBal);

        require(_slippageAmt <= buyAmt, "Too much slippage");
    }
}

contract OneInchResolver is OneProtoResolver {
    function CHECKONEINCHSIG202(bytes memory callData) internal pure returns(bool isOk) {	//inject NONSTANDARD NAMING
        bytes memory _data = callData;
        bytes4 sig;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            sig := mload(add(_data, 32))
        }
        isOk = sig == GETONEINCHSIG889();
    }

    struct OneInchData {
        TokenInterface sellToken;
        TokenInterface buyToken;
        uint _sellAmt;
        uint _buyAmt;
        uint unitAmt;
        bytes callData;
    }

    function ONEINCHSWAP719(	//inject NONSTANDARD NAMING
        OneInchData memory oneInchData,
        uint ethAmt
    ) internal returns (uint buyAmt) {
        TokenInterface buyToken = oneInchData.buyToken;
        (uint _buyDec, uint _sellDec) = GETTOKENSDEC172(buyToken, oneInchData.sellToken);
        uint _sellAmt18 = CONVERTTO18179(_sellDec, oneInchData._sellAmt);
        uint _slippageAmt = CONVERT18TODEC395(_buyDec, WMUL242(oneInchData.unitAmt, _sellAmt18));

        uint initalBal = GETTOKENBAL438(buyToken);

        // solium-disable-next-line security/no-call-value
        (bool success, ) = address(GETONEINCHADDRESS518()).call.value(ethAmt)(oneInchData.callData);
        if (!success) revert("1Inch-swap-failed");

        uint finalBal = GETTOKENBAL438(buyToken);

        buyAmt = SUB700(finalBal, initalBal);

        require(_slippageAmt <= buyAmt, "Too much slippage");
    }

}

contract OneProtoEventResolver is OneInchResolver {
    event LOGSELL607(	//inject NONSTANDARD NAMING
        address indexed buyToken,
        address indexed sellToken,
        uint256 buyAmt,
        uint256 sellAmt,
        uint256 getId,
        uint256 setId
    );

    function EMITLOGSELL642(	//inject NONSTANDARD NAMING
        OneProtoData memory oneProtoData,
        uint256 getId,
        uint256 setId
    ) internal {
        bytes32 _eventCode;
        bytes memory _eventParam;
        emit LOGSELL607(
            address(oneProtoData.buyToken),
            address(oneProtoData.sellToken),
            oneProtoData._buyAmt,
            oneProtoData._sellAmt,
            getId,
            setId
        );
        _eventCode = keccak256("LogSell(address,address,uint256,uint256,uint256,uint256)");
        _eventParam = abi.encode(
            address(oneProtoData.buyToken),
            address(oneProtoData.sellToken),
            oneProtoData._buyAmt,
            oneProtoData._sellAmt,
            getId,
            setId
        );
        EMITEVENT565(_eventCode, _eventParam);
    }

    event LOGSELLTWO221(	//inject NONSTANDARD NAMING
        address indexed buyToken,
        address indexed sellToken,
        uint256 buyAmt,
        uint256 sellAmt,
        uint256 getId,
        uint256 setId
    );

    function EMITLOGSELLTWO898(	//inject NONSTANDARD NAMING
        OneProtoData memory oneProtoData,
        uint256 getId,
        uint256 setId
    ) internal {
        bytes32 _eventCode;
        bytes memory _eventParam;
        emit LOGSELLTWO221(
            address(oneProtoData.buyToken),
            address(oneProtoData.sellToken),
            oneProtoData._buyAmt,
            oneProtoData._sellAmt,
            getId,
            setId
        );
        _eventCode = keccak256("LogSellTwo(address,address,uint256,uint256,uint256,uint256)");
        _eventParam = abi.encode(
            address(oneProtoData.buyToken),
            address(oneProtoData.sellToken),
            oneProtoData._buyAmt,
            oneProtoData._sellAmt,
            getId,
            setId
        );
        EMITEVENT565(_eventCode, _eventParam);
    }

    event LOGSELLMULTI397(	//inject NONSTANDARD NAMING
        address[] tokens,
        address indexed buyToken,
        address indexed sellToken,
        uint256 buyAmt,
        uint256 sellAmt,
        uint256 getId,
        uint256 setId
    );

    function EMITLOGSELLMULTI751(	//inject NONSTANDARD NAMING
        OneProtoMultiData memory oneProtoData,
        uint256 getId,
        uint256 setId
    ) internal {
        bytes32 _eventCode;
        bytes memory _eventParam;
        emit LOGSELLMULTI397(
            oneProtoData.tokens,
            address(oneProtoData.buyToken),
            address(oneProtoData.sellToken),
            oneProtoData._buyAmt,
            oneProtoData._sellAmt,
            getId,
            setId
        );
        _eventCode = keccak256("LogSellMulti(address[],address,address,uint256,uint256,uint256,uint256)");
        _eventParam = abi.encode(
            oneProtoData.tokens,
            address(oneProtoData.buyToken),
            address(oneProtoData.sellToken),
            oneProtoData._buyAmt,
            oneProtoData._sellAmt,
            getId,
            setId
        );
        EMITEVENT565(_eventCode, _eventParam);
    }
}

contract OneInchEventResolver is OneProtoEventResolver {
    event LOGSELLTHREE365(	//inject NONSTANDARD NAMING
        address indexed buyToken,
        address indexed sellToken,
        uint256 buyAmt,
        uint256 sellAmt,
        uint256 getId,
        uint256 setId
    );

    function EMITLOGSELLTHREE379(	//inject NONSTANDARD NAMING
        OneInchData memory oneInchData,
        uint256 setId
    ) internal {
        bytes32 _eventCode;
        bytes memory _eventParam;
        emit LOGSELLTHREE365(
            address(oneInchData.buyToken),
            address(oneInchData.sellToken),
            oneInchData._buyAmt,
            oneInchData._sellAmt,
            0,
            setId
        );
        _eventCode = keccak256("LogSellThree(address,address,uint256,uint256,uint256,uint256)");
        _eventParam = abi.encode(
            address(oneInchData.buyToken),
            address(oneInchData.sellToken),
            oneInchData._buyAmt,
            oneInchData._sellAmt,
            0,
            setId
        );
        EMITEVENT565(_eventCode, _eventParam);
    }
}

contract OneProtoResolverHelpers is OneInchEventResolver {
    function _SELL499(	//inject NONSTANDARD NAMING
        OneProtoData memory oneProtoData,
        uint256 getId,
        uint256 setId
    ) internal {
        uint _sellAmt = GETUINT774(getId, oneProtoData._sellAmt);

        oneProtoData._sellAmt = _sellAmt == uint(-1) ?
            GETTOKENBAL438(oneProtoData.sellToken) :
            _sellAmt;

        OneProtoInterface oneProtoContract = OneProtoInterface(GETONEPROTOADDRESS431());

        (, oneProtoData.distribution) = oneProtoContract.GETEXPECTEDRETURN579(
                oneProtoData.sellToken,
                oneProtoData.buyToken,
                oneProtoData._sellAmt,
                5,
                0
            );

        oneProtoData._buyAmt = ONEPROTOSWAP794(
            oneProtoContract,
            oneProtoData
        );

        SETUINT548(setId, oneProtoData._buyAmt);

        EMITLOGSELL642(oneProtoData, getId, setId);
    }

    function _SELLTWO817(	//inject NONSTANDARD NAMING
        OneProtoData memory oneProtoData,
        uint getId,
        uint setId
    ) internal {
        uint _sellAmt = GETUINT774(getId, oneProtoData._sellAmt);

        oneProtoData._sellAmt = _sellAmt == uint(-1) ?
            GETTOKENBAL438(oneProtoData.sellToken) :
            _sellAmt;

        oneProtoData._buyAmt = ONEPROTOSWAP794(
            OneProtoInterface(GETONEPROTOADDRESS431()),
            oneProtoData
        );

        SETUINT548(setId, oneProtoData._buyAmt);
        EMITLOGSELLTWO898(oneProtoData, getId, setId);
    }

    function _SELLMULTI27(	//inject NONSTANDARD NAMING
        OneProtoMultiData memory oneProtoData,
        uint getId,
        uint setId
    ) internal {
        uint _sellAmt = GETUINT774(getId, oneProtoData._sellAmt);

        oneProtoData._sellAmt = _sellAmt == uint(-1) ?
            GETTOKENBAL438(oneProtoData.sellToken) :
            _sellAmt;

        oneProtoData._buyAmt = ONEPROTOSWAPMULTI285(oneProtoData);
        SETUINT548(setId, oneProtoData._buyAmt);

        EMITLOGSELLMULTI751(oneProtoData, getId, setId);
    }
}

contract OneInchResolverHelpers is OneProtoResolverHelpers {
    function _SELLTHREE9(	//inject NONSTANDARD NAMING
        OneInchData memory oneInchData,
        uint setId
    ) internal {
        TokenInterface _sellAddr = oneInchData.sellToken;

        uint ethAmt;
        if (address(_sellAddr) == GETETHADDR620()) {
            ethAmt = oneInchData._sellAmt;
        } else {
            TokenInterface(_sellAddr).APPROVE44(GETONEINCHTOKENTAKER586(), oneInchData._sellAmt);
        }

        require(CHECKONEINCHSIG202(oneInchData.callData), "Not-swap-function");

        oneInchData._buyAmt = ONEINCHSWAP719(oneInchData, ethAmt);
        SETUINT548(setId, oneInchData._buyAmt);

        EMITLOGSELLTHREE379(oneInchData, setId);
    }
}

contract OneProto is OneInchResolverHelpers {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function SELL474(	//inject NONSTANDARD NAMING
        address buyAddr,
        address sellAddr,
        uint sellAmt,
        uint unitAmt,
        uint getId,
        uint setId
    ) external payable {
        OneProtoData memory oneProtoData = OneProtoData({
            buyToken: TokenInterface(buyAddr),
            sellToken: TokenInterface(sellAddr),
            _sellAmt: sellAmt,
            unitAmt: unitAmt,
            distribution: new uint[](0),
            _buyAmt: 0,
            disableDexes: 0
        });

        _SELL499(oneProtoData, getId, setId);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function SELLTWO782(	//inject NONSTANDARD NAMING
        address buyAddr,
        address sellAddr,
        uint sellAmt,
        uint unitAmt,
        uint[] calldata distribution,
        uint disableDexes,
        uint getId,
        uint setId
    ) external payable {
        OneProtoData memory oneProtoData = OneProtoData({
            buyToken: TokenInterface(buyAddr),
            sellToken: TokenInterface(sellAddr),
            _sellAmt: sellAmt,
            unitAmt: unitAmt,
            distribution: distribution,
            disableDexes: disableDexes,
            _buyAmt: 0
        });

        _SELLTWO817(oneProtoData, getId, setId);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function SELLMULTI899(	//inject NONSTANDARD NAMING
        address[] calldata tokens,
        uint sellAmt,
        uint unitAmt,
        uint[] calldata distribution,
        uint[] calldata disableDexes,
        uint getId,
        uint setId
    ) external payable {
        OneProtoMultiData memory oneProtoData = OneProtoMultiData({
            tokens: tokens,
            buyToken: TokenInterface(address(tokens[tokens.length - 1])),
            sellToken: TokenInterface(address(tokens[0])),
            unitAmt: unitAmt,
            distribution: distribution,
            disableDexes: disableDexes,
            _sellAmt: sellAmt,
            _buyAmt: 0
        });

        _SELLMULTI27(oneProtoData, getId, setId);
    }
}

contract OneInch is OneProto {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function SELLTHREE242(	//inject NONSTANDARD NAMING
        address buyAddr,
        address sellAddr,
        uint sellAmt,
        uint unitAmt,
        bytes calldata callData,
        uint setId
    ) external payable {
        OneInchData memory oneInchData = OneInchData({
            buyToken: TokenInterface(buyAddr),
            sellToken: TokenInterface(sellAddr),
            unitAmt: unitAmt,
            callData: callData,
            _sellAmt: sellAmt,
            _buyAmt: 0
        });

        _SELLTHREE9(oneInchData, setId);
    }
}

contract ConnectOne is OneInch {
    string public name = "1inch-1proto-v1";
}