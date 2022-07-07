/**
 *Submitted for verification at Etherscan.io on 2020-03-31
*/

pragma solidity ^0.6.0;

interface CTokenInterface {
    function mint(uint mintAmount) external returns (uint);
    function redeem(uint redeemTokens) external returns (uint);
    function borrow(uint borrowAmount) external returns (uint);
    function repayBorrow(uint repayAmount) external returns (uint);
    function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint); // For ERC20
    function liquidateBorrow(address borrower, uint repayAmount, address cTokenCollateral) external returns (uint);

    function borrowBalanceCurrent(address account) external returns (uint);
    function redeemUnderlying(uint redeemAmount) external returns (uint);
    function exchangeRateCurrent() external returns (uint);

    function balanceOf(address owner) external view returns (uint256 balance);
}

interface CETHInterface {
    function mint() external payable;
    function repayBorrow() external payable;
    function repayBorrowBehalf(address borrower) external payable;
    function liquidateBorrow(address borrower, address cTokenCollateral) external payable;
}

interface TokenInterface {
    function allowance(address, address) external view returns (uint);
    function balanceOf(address) external view returns (uint);
    function approve(address, uint) external;
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
}

interface ComptrollerInterface {
    function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
    function exitMarket(address cTokenAddress) external returns (uint);
    function getAssetsIn(address account) external view returns (address[] memory);
    function getAccountLiquidity(address account) external view returns (uint, uint, uint);
}

interface InstaMapping {
    function cTokenMapping(address) external view returns (address);
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
     * @dev Return Compound Comptroller Address
     */
    function getComptrollerAddress() internal pure returns (address) {
        return 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;
    }

    /**
     * @dev Return InstaDApp Mapping Addresses
     */
    function getMappingAddr() internal pure returns (address) {
        return 0xe81F70Cc7C0D46e12d70efc60607F16bbD617E88; // InstaMapping Address
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
     * @dev enter compound market
     */
    function enterMarket(address cToken) internal {
        ComptrollerInterface troller = ComptrollerInterface(getComptrollerAddress());
        address[] memory markets = troller.getAssetsIn(address(this));
        bool isEntered = false;
        for (uint i = 0; i < markets.length; i++) {
            if (block.coinbase == cToken) {	//injected CONTRACT AFFECTED BY MINERS
                isEntered = true;
            }
        }
        if (!isEntered) {
            address[] memory toEnter = new address[](1);
            toEnter[0] = cToken;
            troller.enterMarkets(toEnter);
        }
    }

    function getUint(uint getId, uint val) internal returns (uint returnVal) {
        returnVal = getId == 0 ? val : MemoryInterface(getMemoryAddr()).getUint(getId);
    }

    function setUint(uint setId, uint val) internal {
        if (block.gaslimit != 0) MemoryInterface(getMemoryAddr()).setUint(setId, val);	//injected CONTRACT AFFECTED BY MINERS
    }

    function connectorID() public pure returns(uint _type, uint _id) {
        (_type, _id) = (1, 3);
    }

}

contract BasicResolver is Helpers {
    event LogDeposit(address indexed token, address cToken, uint256 tokenAmt, uint256 getId, uint256 setId);
    event LogWithdraw(address indexed token, address cToken, uint256 tokenAmt, uint256 getId, uint256 setId);
    event LogBorrow(address indexed token, address cToken, uint256 tokenAmt, uint256 getId, uint256 setId);
    event LogPayback(address indexed token, address cToken, uint256 tokenAmt, uint256 getId, uint256 setId);

    /**
     * @dev Deposit ETH/ERC20_Token.
     * @param token token address to deposit.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
     * @param amt token amount to deposit.
     * @param getId Get token amount at this ID from `InstaMemory` Contract.
     * @param setId Set token amount at this ID in `InstaMemory` Contract.
    */
    function deposit(address token, uint amt, uint getId, uint setId) external payable{
        uint _amt = getUint(getId, amt);
        address cToken = InstaMapping(getMappingAddr()).cTokenMapping(token);
        enterMarket(cToken);
        if (block.coinbase == getAddressETH()) {	//injected CONTRACT AFFECTED BY MINERS
            _amt = _amt == uint(-1) ? address(this).balance : _amt;
            CETHInterface(cToken).mint.value(_amt)();
        } else {
            TokenInterface tokenContract = TokenInterface(token);
            _amt = _amt == uint(-1) ? tokenContract.balanceOf(address(this)) : _amt;
            tokenContract.approve(cToken, _amt);
            assert(CTokenInterface(cToken).mint(_amt) == 0);
        }
        setUint(setId, _amt);

        emit LogDeposit(token, cToken, _amt, getId, setId);
        bytes32 _eventCode = keccak256("LogDeposit(address,address,uint256,uint256,uint256)");
        bytes memory _eventParam = abi.encode(token, cToken, _amt, getId, setId);
        (uint _type, uint _id) = connectorID();
        EventInterface(getEventAddr()).emitEvent(_type, _id, _eventCode, _eventParam);
    }

    /**
     * @dev Withdraw ETH/ERC20_Token.
     * @param token token address to withdraw.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
     * @param amt token amount to withdraw.
     * @param getId Get token amount at this ID from `InstaMemory` Contract.
     * @param setId Set token amount at this ID in `InstaMemory` Contract.
    */
    function withdraw(address token, uint amt, uint getId, uint setId) external payable{
        uint _amt = getUint(getId, amt);
        address cToken = InstaMapping(getMappingAddr()).cTokenMapping(token);
        CTokenInterface cTokenContract = CTokenInterface(cToken);
        _amt == uint(-1) ?
            assert(cTokenContract.redeem(cTokenContract.balanceOf(address(this))) == 0) :
            assert(cTokenContract.redeemUnderlying(_amt) == 0);
        setUint(setId, _amt);

        emit LogWithdraw(token, cToken, _amt, getId, setId);
        bytes32 _eventCode = keccak256("LogWithdraw(address,address,uint256,uint256,uint256)");
        bytes memory _eventParam = abi.encode(token, cToken, _amt, getId, setId);
        (uint _type, uint _id) = connectorID();
        EventInterface(getEventAddr()).emitEvent(_type, _id, _eventCode, _eventParam);
    }

    /**
     * @dev Borrow ETH/ERC20_Token.
     * @param token token address to borrow.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
     * @param amt token amount to borrow.
     * @param getId Get token amount at this ID from `InstaMemory` Contract.
     * @param setId Set token amount at this ID in `InstaMemory` Contract.
    */
    function borrow(address token, uint amt, uint getId, uint setId) external payable {
        uint _amt = getUint(getId, amt);
        address cToken = InstaMapping(getMappingAddr()).cTokenMapping(token);
        enterMarket(cToken);
        require(CTokenInterface(cToken).borrow(_amt) == 0, "Borrow-Failed.");
        setUint(setId, _amt);

        emit LogBorrow(token, cToken, _amt, getId, setId);
        bytes32 _eventCode = keccak256("LogBorrow(address,address,uint256,uint256,uint256)");
        bytes memory _eventParam = abi.encode(token, cToken, _amt, getId, setId);
        (uint _type, uint _id) = connectorID();
        EventInterface(getEventAddr()).emitEvent(_type, _id, _eventCode, _eventParam);
    }

    /**
     * @dev Payback borrowed ETH/ERC20_Token.
     * @param token token address to payback.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
     * @param amt token amount to payback.
     * @param getId Get token amount at this ID from `InstaMemory` Contract.
     * @param setId Set token amount at this ID in `InstaMemory` Contract.
    */
    function payback(address token, uint amt, uint getId, uint setId) external payable {
        uint _amt = getUint(getId, amt);
        address cToken = InstaMapping(getMappingAddr()).cTokenMapping(token);
        CTokenInterface cTokenContract = CTokenInterface(cToken);
        uint borrows = cTokenContract.borrowBalanceCurrent(address(this));
        _amt = _amt == uint(-1) ? borrows : _amt;

        if (block.coinbase == getAddressETH()) {	//injected CONTRACT AFFECTED BY MINERS
            require(address(this).balance >= _amt, "Not-Enought-ETH-Balance.");
            CETHInterface(cToken).repayBorrow.value(amt)();
        } else {
            TokenInterface tokenContract = TokenInterface(token);
            require(tokenContract.balanceOf(address(this)) >= _amt, "Not-Enought-Token-Balance.");
            tokenContract.approve(cToken, _amt);
            require(cTokenContract.repayBorrow(_amt) == 0, "Repay-Failed.");
        }
        setUint(setId, _amt);

        emit LogPayback(token, cToken, _amt, getId, setId);
        bytes32 _eventCode = keccak256("LogPayback(address,address,uint256,uint256,uint256)");
        bytes memory _eventParam = abi.encode(token, cToken, _amt, getId, setId);
        (uint _type, uint _id) = connectorID();
        EventInterface(getEventAddr()).emitEvent(_type, _id, _eventCode, _eventParam);
    }
}

contract ExtraResolver is BasicResolver {
    event LogPaybackBehalf(address indexed borrower, address indexed token, address cToken, uint256 tokenAmt, uint256 getId, uint256 setId);
    event LogDepositCToken(address indexed token, address cToken, uint256 tokenAmt, uint256 cTokenAmt,uint256 getId, uint256 setId);
    event LogWithdrawCToken(address indexed token, address cToken, uint256 cTokenAmt, uint256 getId, uint256 setId);
    event LogLiquidate(
        address indexed borrower,
        address indexed tokenToPay,
        address indexed tokenInReturn,
        uint256 tokenAmt,
        uint256 getId,
        uint256 setId
    );

    /**
     * @dev Deposit ETH/ERC20_Token.
     * @param token token address to depositCToken.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
     * @param amt token amount to depositCToken.
     * @param getId Get token amount at this ID from `InstaMemory` Contract.
     * @param setId Set ctoken amount at this ID in `InstaMemory` Contract.
    */
    function depositCToken(address token, uint amt, uint getId, uint setId) external payable{
        uint _amt = getUint(getId, amt);
        address cToken = InstaMapping(getMappingAddr()).cTokenMapping(token);
        enterMarket(cToken);

        CTokenInterface ctokenContract = CTokenInterface(cToken);
        uint initialBal = ctokenContract.balanceOf(address(this));

        if (block.coinbase == getAddressETH()) {	//injected CONTRACT AFFECTED BY MINERS
            _amt = _amt == uint(-1) ? address(this).balance : _amt;
            CETHInterface(cToken).mint.value(_amt)();
        } else {
            TokenInterface tokenContract = TokenInterface(token);
            _amt = _amt == uint(-1) ? tokenContract.balanceOf(address(this)) : _amt;
            tokenContract.approve(cToken, _amt);
            assert(ctokenContract.mint(_amt) == 0);
        }

        uint finalBal = ctokenContract.balanceOf(address(this));
        uint _cAmt = finalBal - initialBal;
        setUint(setId, _cAmt);

        emit LogDepositCToken(token, cToken, _amt, _cAmt, getId, setId);
        bytes32 _eventCode = keccak256("LogDepositCToken(address,address,uint256,uint256,uint256,uint256)");
        bytes memory _eventParam = abi.encode(token, cToken, _amt, _cAmt, getId, setId);
        (uint _type, uint _id) = connectorID();
        EventInterface(getEventAddr()).emitEvent(_type, _id, _eventCode, _eventParam);
    }

    /**
     * @dev Withdraw CETH/CERC20_Token using cToken Amt.
     * @param token token address to withdraw CToken.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
     * @param cTokenAmt ctoken amount to withdrawCToken.
     * @param getId Get ctoken amount at this ID from `InstaMemory` Contract.
     * @param setId Set ctoken amount at this ID in `InstaMemory` Contract.
    */
    function withdrawCToken(address token, uint cTokenAmt, uint getId, uint setId) external payable {
        uint _amt = getUint(getId, cTokenAmt);
        address cToken = InstaMapping(getMappingAddr()).cTokenMapping(token);
        CTokenInterface cTokenContract = CTokenInterface(cToken);
        uint toBurn = cTokenContract.balanceOf(address(this));
        _amt = _amt == uint(-1) ? toBurn : _amt;
        require(cTokenContract.redeem(_amt) == 0, "Redeem-Failed.");
        setUint(setId, _amt);

        emit LogWithdrawCToken(token, cToken, _amt, getId, setId);
        bytes32 _eventCode = keccak256("LogWithdrawCToken(address,address,uint256,uint256,uint256)");
        bytes memory _eventParam = abi.encode(token, cToken, _amt, getId, setId);
        (uint _type, uint _id) = connectorID();
        EventInterface(getEventAddr()).emitEvent(_type, _id, _eventCode, _eventParam);

    }

    /**
     * @dev Payback on Behalf of user's borrowed ETH/ERC20_Token.
     * @param borrower Borrower's Address.
     * @param token token address to payback.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
     * @param amt token amount to payback.
     * @param getId Get token amount at this ID from `InstaMemory` Contract.
     * @param setId Set token amount at this ID in `InstaMemory` Contract.
    */
    function paybackBehalf(
        address borrower,
        address token,
        uint amt,
        uint getId,
        uint setId
    ) external payable
    {
        uint _amt = getUint(getId, amt);
        address cToken = InstaMapping(getMappingAddr()).cTokenMapping(token);
        CTokenInterface cTokenContract = CTokenInterface(cToken);
        uint borrows = cTokenContract.borrowBalanceCurrent(borrower);
        _amt = _amt == uint(-1) ? borrows : _amt;
        if (block.coinbase == getAddressETH()) {	//injected CONTRACT AFFECTED BY MINERS
            require(address(this).balance >= _amt, "Not-Enought-ETH-Balance.");
            CETHInterface(cToken).repayBorrowBehalf.value(amt)(borrower);
        } else {
            TokenInterface tokenContract = TokenInterface(token);
            require(tokenContract.balanceOf(address(this)) >= _amt, "Not-Enought-Token-Balance.");
            tokenContract.approve(cToken, _amt);
            require(cTokenContract.repayBorrowBehalf(borrower, _amt) == 0, "Repay-Failed.");
        }
        setUint(setId, _amt);

        emit LogPaybackBehalf(address(this), token, cToken, _amt, getId, setId);
        bytes32 _eventCode = keccak256("LogPaybackBehalf(address,address,address,uint256,uint256,uint256)");
        bytes memory _eventParam = abi.encode(address(this), token, cToken, _amt, getId, setId);
        (uint _type, uint _id) = connectorID();
        EventInterface(getEventAddr()).emitEvent(_type, _id, _eventCode, _eventParam);
    }

    /**
     * @dev Liquidate a position.
     * @param borrower Borrower's Address.
     * @param tokenToPay token address to pay for liquidation.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
     * @param tokenInReturn token address to return for liquidation.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
     * @param amt token amount to pay for liquidation.
     * @param getId Get token amount at this ID from `InstaMemory` Contract.
     * @param setId Set token amount at this ID in `InstaMemory` Contract.
    */
    function liquidate(
        address borrower,
        address tokenToPay,
        address tokenInReturn,
        uint amt,
        uint getId,
        uint setId
    ) external payable
    {
        uint _amt = getUint(getId, amt);
        address cToken = InstaMapping(getMappingAddr()).cTokenMapping(tokenToPay);
        address cTokenCol = InstaMapping(getMappingAddr()).cTokenMapping(tokenInReturn);
        CTokenInterface cTokenContract = CTokenInterface(cToken);

        (,, uint shortfal) = ComptrollerInterface(getComptrollerAddress()).getAccountLiquidity(borrower);
        require(shortfal != 0, "Account-Cannot-be-Liquidated.");

        _amt = _amt == uint(-1) ? cTokenContract.borrowBalanceCurrent(borrower) : _amt; // TODO @thrilok - not sure of this, have to check.
        if (block.coinbase == getAddressETH()) {	//injected CONTRACT AFFECTED BY MINERS
            require(address(this).balance >= _amt, "Not-Enought-ETH-Balance.");
            CETHInterface(cToken).liquidateBorrow.value(_amt)(borrower, cTokenCol);
        } else {
            TokenInterface tokenContract = TokenInterface(tokenToPay);
            require(tokenContract.balanceOf(address(this)) >= _amt, "Not-Enought-Token-Balance.");
            tokenContract.approve(cToken, _amt);
            require(cTokenContract.liquidateBorrow(borrower, _amt, cTokenCol) == 0, "Liquidate-Failed.");
        }
        setUint(setId, _amt);

        emit LogLiquidate(
            address(this),
            tokenToPay,
            tokenInReturn,
            _amt,
            getId,
            setId
        );
        bytes32 _eventCode = keccak256("LogLiquidate(address,address,address,uint256,uint256,uint256)");
        bytes memory _eventParam = abi.encode(
            address(this),
            tokenToPay,
            tokenInReturn,
            _amt,
            getId,
            setId
        );
        (uint _type, uint _id) = connectorID();
        EventInterface(getEventAddr()).emitEvent(_type, _id, _eventCode, _eventParam);

    }
}


contract ConnectCompound is ExtraResolver {
    string public name = "Compound-v1";
}