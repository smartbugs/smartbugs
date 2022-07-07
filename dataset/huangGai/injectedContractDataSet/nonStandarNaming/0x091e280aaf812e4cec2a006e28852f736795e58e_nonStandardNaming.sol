pragma solidity ^0.5.7;



library SafeMath256 {

    function ADD150(uint256 a, uint256 b) internal pure returns (uint256 c) {	//inject NONSTANDARD NAMING
        c = a + b;
        assert(c >= a);
        return c;
    }


    function SUB227(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        assert(b <= a);
        return a - b;
    }

    function MUL533(uint256 a, uint256 b) internal pure returns (uint256 c) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }


    function DIV196(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        assert(b > 0);
        uint256 c = a / b;
        assert(a == b * c + a % b);
        return a / b;
    }


    function MOD289(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0);
        return a % b;
    }
}


contract Ownable {
    address private _owner;
    address payable internal _receiver;

    event OWNERSHIPTRANSFERRED323(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING
    event RECEIVERCHANGED169(address indexed previousReceiver, address indexed newReceiver);	//inject NONSTANDARD NAMING


    constructor () internal {
        _owner = msg.sender;
        _receiver = msg.sender;
    }


    function OWNER925() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }


    modifier ONLYOWNER749() {	//inject NONSTANDARD NAMING
        require(msg.sender == _owner);
        _;
    }


    function TRANSFEROWNERSHIP381(address newOwner) external ONLYOWNER749 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0));
        address __previousOwner = _owner;
        _owner = newOwner;
        emit OWNERSHIPTRANSFERRED323(__previousOwner, newOwner);
    }


    function CHANGERECEIVER952(address payable newReceiver) external ONLYOWNER749 {	//inject NONSTANDARD NAMING
        require(newReceiver != address(0));
        address __previousReceiver = _receiver;
        _receiver = newReceiver;
        emit RECEIVERCHANGED169(__previousReceiver, newReceiver);
    }


    function RESCUETOKENS654(address tokenAddress, address receiver, uint256 amount) external ONLYOWNER749 {	//inject NONSTANDARD NAMING
        IERC20 _token = IERC20(tokenAddress);
        require(receiver != address(0));
        uint256 balance = _token.BALANCEOF741(address(this));
        require(balance >= amount);

        assert(_token.TRANSFER337(receiver, amount));
    }


    function WITHDRAWETHER185(address payable to, uint256 amount) external ONLYOWNER749 {	//inject NONSTANDARD NAMING
        require(to != address(0));
        uint256 balance = address(this).balance;
        require(balance >= amount);

        to.transfer(amount);
    }
}



contract Pausable is Ownable {
    bool private _paused;

    event PAUSED297(address account);	//inject NONSTANDARD NAMING
    event UNPAUSED13(address account);	//inject NONSTANDARD NAMING

    constructor () internal {
        _paused = false;
    }


    function PAUSED795() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _paused;
    }


    modifier WHENNOTPAUSED248() {	//inject NONSTANDARD NAMING
        require(!_paused, "Paused.");
        _;
    }


    function SETPAUSED829(bool state) external ONLYOWNER749 {	//inject NONSTANDARD NAMING
        if (_paused && !state) {
            _paused = false;
            emit UNPAUSED13(msg.sender);
        } else if (!_paused && state) {
            _paused = true;
            emit PAUSED297(msg.sender);
        }
    }
}


interface IERC20 {
    function BALANCEOF741(address owner) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER337(address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING
}



interface IToken {
    function BALANCEOF741(address owner) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER337(address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING
    function INWHITELIST830(address account) external view returns (bool);	//inject NONSTANDARD NAMING
}



interface ITokenPublicSale {
    function STATUS782() external view returns (uint256 auditEtherPrice,	//inject NONSTANDARD NAMING
        uint16 stage,
        uint16 season,
        uint256 tokenUsdPrice,
        uint256 currentTopSalesRatio,
        uint256 txs,
        uint256 tokenTxs,
        uint256 tokenBonusTxs,
        uint256 tokenWhitelistTxs,
        uint256 tokenIssued,
        uint256 tokenBonus,
        uint256 tokenWhitelist);
}


contract Get102Token is Ownable, Pausable {
    using SafeMath256 for uint256;

    IToken           public TOKEN             = IToken(0x13bB73376c18faB89Dd5143D50BeF64d9D865200);
    ITokenPublicSale public TOKEN_PUBLIC_SALE = ITokenPublicSale(0xE94F0adA89B3CFecb7645911898b3907170Bf7CB);

    uint256 private WEI_MIN = 1 ether;
    uint256 private TOKEN_PER_TXN = 102000000; // 102.000000 TM Token

    uint256 private _txs;

    mapping (address => bool) _alreadyGot;

    event TX981(uint256 etherPrice, uint256 vokdnUsdPrice, uint256 weiUsed);	//inject NONSTANDARD NAMING


    function TXS747() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _txs;
    }


    function () external payable WHENNOTPAUSED248 {
        require(msg.value >= WEI_MIN);
        require(TOKEN.BALANCEOF741(address(this)) >= TOKEN_PER_TXN);
        require(TOKEN.BALANCEOF741(msg.sender) == 0);
        require(!TOKEN.INWHITELIST830(msg.sender));
        require(!_alreadyGot[msg.sender]);

        uint256 __etherPrice;
        uint256 __tokenUsdPrice;
        (__etherPrice, , , __tokenUsdPrice, , , , , , , ,) = TOKEN_PUBLIC_SALE.STATUS782();

        require(__etherPrice > 0);

        uint256 __usd = TOKEN_PER_TXN.MUL533(__tokenUsdPrice).DIV196(1000000);
        uint256 __wei = __usd.MUL533(1 ether).DIV196(__etherPrice);

        require(msg.value >= __wei);

        if (msg.value > __wei) {
            msg.sender.transfer(msg.value.SUB227(__wei));
            _receiver.transfer(__wei);
        }

        _txs = _txs.ADD150(1);
        _alreadyGot[msg.sender] = true;
        emit TX981(__etherPrice, __tokenUsdPrice, __wei);

        assert(TOKEN.TRANSFER337(msg.sender, TOKEN_PER_TXN));
    }
}