pragma solidity ^0.5.2;


/**
 *  URA Mraket contract
 *  web site: ura.market
 *
 *  URA.market  is a decentralized trade and investment platform, created by Ethereum net.
 *
 *  URA.market is controlled without human participation,
 *  and by automated smart contracts with refusal from ownership activated function.
 *
 * Gas limit: 150 000 (only the first time, average ~ 50 000)
 * Gas price: https://ethgasstation.info/
 *
 * github: https://github.com/bigdaddy777/URA-MARKET-COIN
 */


library ToAddress {
    function toAddr(uint _source) internal pure returns(address payable) {
        return address(_source);
    }

    function toAddr(bytes memory _source) internal pure returns(address payable addr) {
        // solium-disable security/no-inline-assembly
        assembly { addr := mload(add(_source,0x14)) }
        return addr;
    }

    function isNotContract(address addr) internal view returns(bool) {
        // solium-disable security/no-inline-assembly
        uint256 length;
        assembly { length := extcodesize(addr) }
        return length == 0;
    }
}


/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

    /**
    * @dev Multiplies two numbers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0); // Solidity only automatically asserts when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two numbers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}


// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// @wiki: https://theethereum.wiki/w/index.php/ERC20_Token_Standard
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function tokensOwner() public view returns (uint256);
    function contracBalance() public view returns (uint256);
    function balanceOf(address _tokenOwner) public view returns (uint256 balanceOwner);

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event EtherTransfer(address indexed from, address indexed to, uint256 etherAmount);
}


// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol.
// ----------------------------------------------------------------------------
contract ERC20 is ERC20Interface {
    using SafeMath for uint;
    using ToAddress for *;

    string constant public symbol = "URA";
    string constant public  name = "URA market coin";
    uint8 constant internal decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) balances;


    // ------------------------------------------------------------------------
    // Get balance on contract
    // ------------------------------------------------------------------------
    function contracBalance() public view returns (uint256 contractBalance) {
        contractBalance = address(this).balance;
    }


    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function balanceOf(address _tokenOwner) public view returns (uint256 balanceOwner) {
        return balances[_tokenOwner];
    }


    // ------------------------------------------------------------------------
    // Addon shows caller tokens.
    // ------------------------------------------------------------------------
    function tokensOwner() public view returns (uint256 tokens) {
        tokens = balances[msg.sender];
    }

}


// ----------------------------------------------------------------------------
// Bookeeper contract that holds the amount of dividents in Ether.
// ----------------------------------------------------------------------------
contract Dividend is ERC20 {

    uint8 public constant dividendsCosts = 10; // Dividends 10%.
    uint16 public constant day = 6000;
    uint256 public dividendes; // storage for Dividends.

    mapping(address => uint256) bookKeeper;


    event SendOnDividend(address indexed customerAddress, uint256 dividendesAmount);
    event WithdrawDividendes(address indexed customerAddress, uint256 dividendesAmount);

    constructor() public {}


    // ------------------------------------------------------------------------
    // Withdraw dividendes.
    // ------------------------------------------------------------------------
    function withdrawDividendes() external payable returns(bool success) {
        require(msg.sender.isNotContract(),
                "the contract can not hold tokens");

        uint256 _tokensOwner = balanceOf(msg.sender);

        require(_tokensOwner > 0, "cannot pass 0 value");
        require(bookKeeper[msg.sender] > 0,
                "to withdraw dividends, please wait");

        uint256 _dividendesAmount = dividendesCalc(_tokensOwner);

        require(_dividendesAmount > 0, "dividendes amount > 0");

        bookKeeper[msg.sender] = block.number;
        dividendes = dividendes.sub(_dividendesAmount);

        msg.sender.transfer(_dividendesAmount);

        emit WithdrawDividendes(msg.sender, _dividendesAmount);

        return true;
    }


    // ------------------------------------------------------------------------
    // Get value of dividendes.
    // ------------------------------------------------------------------------
    function dividendesOf(address _owner)
        public
        view
        returns(uint256 dividendesAmount) {
        uint256 _tokens = balanceOf(_owner);

        dividendesAmount = dividendesCalc(_tokens);
    }


    // ------------------------------------------------------------------------
    // Count percent of dividendes from ether.
    // ------------------------------------------------------------------------
    function onDividendes(uint256 _value, uint8 _dividendsCosts)
        internal
        pure
        returns(uint256 forDividendes) {
        return _value.mul(_dividendsCosts).div(100);
    }


    // ------------------------------------------------------------------------
    // Get number of dividendes in ether
    // * @param _tokens: Amount customer tokens.
    // * @param _dividendesPercent: Customer tokens percent in 10e18.
    // *
    // * @retunrs dividendesReceived: amount of dividendes in ether.
    // ------------------------------------------------------------------------
    function dividendesCalc(uint256 _tokensAmount)
        internal
        view
        returns(uint256 dividendesReceived) {
        if (_tokensAmount == 0) {
            return 0;
        }

        uint256 _tokens = _tokensAmount.mul(10e18);
        uint256 _dividendesPercent = dividendesPercent(_tokens); // Get % from tokensOwner.

        dividendesReceived = dividendes.mul(_dividendesPercent).div(100);
        dividendesReceived = dividendesReceived.div(10e18);
    }


    // ------------------------------------------------------------------------
    // Get number of dividendes in percent
    // * @param _tokens: Amount of (tokens * 10e18).
    // * returns: tokens % in 10e18.
    // ------------------------------------------------------------------------
    function dividendesPercent(uint256 _tokens)
        internal
        view
        returns(uint256 percent) {
        if (_tokens == 0) {
            return 0;
        }

        uint256 _interest = accumulatedInterest();

        if (_interest > 100) {
            _interest = 100;
        }

        percent = _tokens.mul(_interest).div(totalSupply);
    }


    // ------------------------------------------------------------------------
    // Block value when buying.
    // ------------------------------------------------------------------------
    function accumulatedInterest() private view returns(uint256 interest) {
        if (bookKeeper[msg.sender] == 0) {
            interest = 0;
        } else {
            interest = block.number.sub(bookKeeper[msg.sender]).div(day);
        }
    }

}


// ----------------------------------------------------------------------------
// URA.market main contract.
// ----------------------------------------------------------------------------
contract URA is ERC20, Dividend {

    // The initial cost of the token, it can not be less. //
    uint128 constant tokenPriceInit = 0.00000000001 ether;
    uint128 public constant limiter = 15 ether;

    uint8 public constant advertisingCosts = 5; // 5% for transfer advertising.
    uint8 public constant forReferralCosts = 2; // 2% for transfer to referral.
    uint8 public constant forWithdrawCosts = 3; // 3% for the withdraw of tokens.

    // For advertising. //
    address payable constant advertising = 0x4d332E1f9d55d9B89dc2a8457B693Beaa7b36b2e;


    event WithdrawTokens(address indexed customerAddress, uint256 ethereumWithdrawn);
    event ReverseAccess(uint256 etherAmount);
    event ForReferral(uint256 etherAmount);


    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor() public { }


    // ------------------------------------------------------------------------
    // Purchase
    // * @param _reverseAccessOfLimiter: Excess value.
    // * @param _aTokenPrice: Price For one token.
    // * @param _forAdvertising: Advertising victim.
    // * @param _forDividendes: Dividend sacrifice.
    // * @param _amountOfTokens: Ether to tokens amount.
    // * @param _reverseAccess: Change remainder in ether.
    // ------------------------------------------------------------------------
    function () external payable {	//inject DOS BY COMPLEX FALLBACK
        require(msg.sender.isNotContract(),
                "the contract can not hold tokens");

        address payable _referralAddress = msg.data.toAddr();
        uint256 _incomingEthereum = msg.value;

        uint256 _forReferral;
        uint256 _reverseAccessOfLimiter;

        if (_incomingEthereum > limiter) {
            _reverseAccessOfLimiter = _incomingEthereum.sub(limiter);
            _incomingEthereum = limiter;
        }

        uint256 _aTokenPrice = tokenPrice();
        uint256 _dividendesOwner = dividendesOf(msg.sender);
        uint256 _forAdvertising = _incomingEthereum.mul(advertisingCosts).div(100);
        uint256 _forDividendes = onDividendes(_incomingEthereum, dividendsCosts);

        if (_referralAddress != address(0)) {
            _forReferral = _incomingEthereum.mul(forReferralCosts).div(100);
            _forAdvertising = _forAdvertising.sub(_forReferral);
        }

        _incomingEthereum = _incomingEthereum.sub(
            _forDividendes
        ).sub(
            _forAdvertising
        ).sub(
            _forReferral
        );

        require(_incomingEthereum >= _aTokenPrice,
                "the amount of ether is not enough");

        (uint256 _amountOfTokens,
         uint256 _reverseAccess) = ethereumToTokens(_incomingEthereum, _aTokenPrice);

        advertising.call.gas(2301).value(_forAdvertising)("");

        _reverseAccessOfLimiter = _reverseAccessOfLimiter.add(_reverseAccess);

        if (_reverseAccessOfLimiter > 0) {
            // If there are leftovers, then return to customer. //
            msg.sender.call.gas(2301).value(_reverseAccessOfLimiter)("");
            emit ReverseAccess(_reverseAccessOfLimiter);
        }
        if (_forReferral > 0 && _referralAddress != address(0)) {
            _referralAddress.call.gas(2301).value(_forReferral)("");
            emit ForReferral(_forReferral);
        }
        if (_dividendesOwner > _aTokenPrice) {
            reinvest();
        }

        bookKeeper[msg.sender] = block.number;
        balances[msg.sender] = balances[msg.sender].add(_amountOfTokens);
        totalSupply = totalSupply.add(_amountOfTokens);
        dividendes = dividendes.add(_forDividendes);

        emit EtherTransfer(msg.sender, advertising, _forAdvertising);
        emit Transfer(address(0), msg.sender, _amountOfTokens);
        emit SendOnDividend(msg.sender, _forDividendes);
    }


    // ------------------------------------------------------------------------
    // Increment for token cost
    // - Dynamic property that is responsible for
    // - the rise and fall of the price of the token.
    // ------------------------------------------------------------------------
    function tokenPrice() public view returns(uint256 priceForToken) {
        uint256 _contracBalance = contracBalance();

        if (totalSupply == 0 || _contracBalance == 0) {
            return tokenPriceInit;
        }

        return _contracBalance.div(totalSupply).mul(4).div(3);
    }


    // ------------------------------------------------------------------------
    // Burning tokens function
    // * @param _valueTokens: Amount tokens for burning.
    // * @param _aTokenPrice: One token price.
    // * @param _etherForTokens: Calculate the ether for burning tokens.
    // * @param _forDividendes: Calculate the are common Dividendes.
    // * @param _contracBalance: Get contract balance.
    // * @param _dividendesAmount: Get the percentage of dividends burned tokens.
    // ------------------------------------------------------------------------
    function withdraw(uint256 _valueTokens) external payable returns(bool success) {
        require(msg.sender.isNotContract(),
                "the contract can not hold tokens");

        uint256 _tokensOwner = balanceOf(msg.sender);

        require(_valueTokens > 0, "cannot pass 0 value");
        require(_tokensOwner >= _valueTokens,
                "you do not have so many tokens");

        uint256 _aTokenPrice = tokenPrice();
        uint256 _etherForTokens = tokensToEthereum(_valueTokens, _aTokenPrice);
        uint256 _contracBalance = contracBalance();
        uint256 _forDividendes = onDividendes(_etherForTokens, forWithdrawCosts);
        uint256 _dividendesAmount = dividendesCalc(_tokensOwner);

        _etherForTokens = _etherForTokens.sub(_forDividendes);
        totalSupply = totalSupply.sub(_valueTokens);

        if (_dividendesAmount > 0) {
            dividendes = dividendes.sub(_dividendesAmount);
            _etherForTokens = _etherForTokens.add(_dividendesAmount);
            emit WithdrawDividendes(msg.sender, _dividendesAmount);
        }
        if (_tokensOwner == _valueTokens) {
            // if the owner out of system //
            bookKeeper[msg.sender] = 0;
            balances[msg.sender] = 0;
        } else {
           bookKeeper[msg.sender] = block.number;
           balances[msg.sender] = balances[msg.sender].sub(_valueTokens);
        }
        if (_etherForTokens > _contracBalance) {
            _etherForTokens = _contracBalance;
        }

        msg.sender.transfer(_etherForTokens);

        emit WithdrawTokens(msg.sender, _etherForTokens);
        emit SendOnDividend(address(0), _forDividendes);

        return true;
    }


    // ------------------------------------------------------------------------
    // Reinvest dividends into tokens
    // ------------------------------------------------------------------------
    function reinvest() public payable returns(bool success) {
        require(msg.sender.isNotContract(),
                "the contract can not hold tokens");

        uint256 _dividendes = dividendesOf(msg.sender);
        uint256 _aTokenPrice = tokenPrice();

        require(_dividendes >= _aTokenPrice, "not enough dividends");

        (uint256 _amountOfTokens,
         uint256 _reverseAccess) = ethereumToTokens(_dividendes, _aTokenPrice);

        require(_amountOfTokens > 0, "tokens amount not zero");

        dividendes = dividendes.sub(_dividendes.sub(_reverseAccess));
        balances[msg.sender] = balances[msg.sender].add(_amountOfTokens);
        totalSupply = totalSupply.add(_amountOfTokens);
        bookKeeper[msg.sender] = block.number;

        emit Transfer(address(0), msg.sender, _amountOfTokens);

        return true;
    }



    // ------------------------------------------------------------------------
    // ether conversion to token
    // ------------------------------------------------------------------------
    function ethereumToTokens(uint256 _incomingEthereum, uint256 _aTokenPrice)
        private
        pure
        returns(uint256 tokensReceived, uint256 reverseAccess) {
        require(_incomingEthereum >= _aTokenPrice,
                "input ether > a token price");

        tokensReceived = _incomingEthereum.div(_aTokenPrice);

        require(tokensReceived > 0, "you can not buy 0 tokens");

        reverseAccess = _incomingEthereum.sub(tokensReceived.mul(_aTokenPrice));
    }


    // ------------------------------------------------------------------------
    // Inverse function ethereumToTokens (Token conversion to ether).
    // ------------------------------------------------------------------------
    function tokensToEthereum(uint256 _tokens, uint256 _aTokenPrice)
        private
        pure
        returns(uint256 etherReceived) {
        require(_tokens > 0, "0 tokens cannot be counted");

        etherReceived = _aTokenPrice.mul(_tokens);
    }

}