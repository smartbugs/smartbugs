/**
 *Submitted for verification at Etherscan.io on 2020-03-09
*/

pragma solidity ^0.5.16;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

contract Ownable {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "msg.sender == owner");
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        require(address(0) != _newOwner, "address(0) != _newOwner");
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner, "msg.sender == newOwner");
        emit OwnershipTransferred(owner, msg.sender);
        owner = msg.sender;
        newOwner = address(0);
    }
}

contract Adminable is Ownable {
    mapping(address => bool) public admins;

    modifier onlyAdmin() {
        require(admins[msg.sender] && msg.sender != owner, "admins[msg.sender] && msg.sender != owner");
        _;
    }

    function setAdmin(address _admin, bool _authorization) public onlyOwner {
        admins[_admin] = _authorization;
    }

}


contract Token {
    function transfer(address _to, uint256 _value) public returns (bool success);
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    uint8 public decimals;
}

contract Dex is Ownable, Adminable {
    using SafeMath for uint256;

    mapping (address => uint256) public invalidOrder;

    function invalidateOrdersBefore(address _user) public onlyAdmin {
        require(now > invalidOrder[_user], "now > invalidOrder[_user]");
        invalidOrder[_user] = now;
    }

    mapping (address => mapping (address => uint256)) public tokens; //mapping of token addresses to mapping of account balances

    mapping (address => uint256) public lastActiveTransaction; // time of last interaction with this contract
    mapping (bytes32 => uint256) public orderFills; //balanceOf order filled

    address public feeAccount;
    uint256 public inactivityReleasePeriod;

    mapping (bytes32 => bool) public hashed; //hashes of: order already traded && funds already hashed && accounts updated

    uint256 public maxFeeWithdrawal;
    uint256 public maxFeeTrade;

    address public dexToken;
    uint256 public dexTokenFeeDiscount;

    mapping (address => bool) public baseCurrency;

    bool internal initialized = true;
    function init(address _feeAccount, address _dexToken, uint256 _dexTokenFeeDiscount, address _admin) public {
        require(!initialized, "!initialized");
        initialized = true;

        feeAccount = _feeAccount;
        dexToken = _dexToken;
        dexTokenFeeDiscount = _dexTokenFeeDiscount;

        inactivityReleasePeriod = 2 weeks;
        maxFeeWithdrawal = 0.05 ether; // max fee rate applied = 5%
        maxFeeTrade = 0.10 ether; // max fee rate applied = 10%

        owner = msg.sender;
        admins[_admin] = true;
    }


    /***************************
     * EDITABLE CONFINGURATION *
     ***************************/

    function setInactivityReleasePeriod(uint256 _expiry) public onlyAdmin returns (bool success) {
        require(_expiry < 26 weeks, "_expiry < 26 weeks");
        inactivityReleasePeriod = _expiry;
        return true;
    }

    function setFeeAccount(address _newFeeAccount) public onlyOwner returns (bool success) {
        feeAccount = _newFeeAccount;
        success = true;
    }

    function setDexToken(address _dexToken) public onlyOwner returns (bool success) {
        dexToken = _dexToken;
        success = true;
    }

    function setDexTokenFeeDiscount(uint256 _dexTokenFeeDiscount) public onlyOwner returns (bool success) {
        dexTokenFeeDiscount = _dexTokenFeeDiscount;
        success = true;
    }

    function setBaseCurrency (address _baseCurrency, bool _boolean) public onlyOwner returns (bool success) {
        baseCurrency[_baseCurrency] = _boolean;
        success = true;
    }

    /***************************
     * UPDATE ACCOUNT ACTIVITY *
     ***************************/
    function updateAccountActivity() public {
        lastActiveTransaction[msg.sender] = now;
    }

    function adminUpdateAccountActivity(address _user, uint256 _expiry, uint8 _v, bytes32 _r, bytes32 _s)
    public onlyAdmin returns(bool success) {
        require(now < _expiry, "should be: now < _expiry");
        bytes32 hash = keccak256(abi.encodePacked(this, _user, _expiry));
        require(!hashed[hash], "!hashed[hash]");
        hashed[hash] = true;

        require(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), _v, _r, _s) == _user,"invalid update account activity signature");

        lastActiveTransaction[_user] = now;
        success = true;
    }

    /*****************
     * DEPOSIT TOKEN *
     *****************/
    event Deposit(address token, address user, uint256 amount, uint256 balance);

    function tokenFallback(address _from, uint256 _amount, bytes memory) public returns(bool) {
        depositTokenFunction(msg.sender, _amount, _from);
        return true;
    }

    function receiveApproval(address _from, uint256 _amount, bytes memory) public returns(bool) {
        transferFromAndDepositTokenFunction(msg.sender, _amount, _from, _from);
        return true;
    }

    function depositToken(address _token, uint256 _amount) public returns(bool) {
        transferFromAndDepositTokenFunction(_token, _amount, msg.sender, msg.sender);
        return true;
    }

    function depositTokenFor(address _token, uint256 _amount, address _beneficiary) public returns(bool) {
        transferFromAndDepositTokenFunction(_token, _amount, msg.sender, _beneficiary);
        return true;
    }

    function transferFromAndDepositTokenFunction (address _token, uint256 _amount, address _sender, address _beneficiary) private {
        require(Token(_token).transferFrom(_sender, address(this), _amount), "Token(_token).transferFrom(_sender, this, _amount)");
        depositTokenFunction(_token, _amount, _beneficiary);
    }

    function depositTokenFunction(address _token, uint256 _amount, address _beneficiary) private {
        tokens[_token][_beneficiary] = tokens[_token][_beneficiary].add(_amount);

        if(tx.origin == _beneficiary) lastActiveTransaction[tx.origin] = now;

        emit Deposit(_token, _beneficiary, _amount, tokens[_token][_beneficiary]);
    }

    /*****************
     * DEPOSIT ETHER *
     *****************/

    function depositEther() public payable {
        depositEtherFor(msg.sender);
    }

    function depositEtherFor(address _beneficiary) public payable {
        tokens[address(0)][_beneficiary] = tokens[address(0)][_beneficiary].add(msg.value);

        if(msg.sender == _beneficiary) lastActiveTransaction[msg.sender] = now;

        emit Deposit(address(0), _beneficiary, msg.value, tokens[address(0)][_beneficiary]);
    }

    /************
     * WITHDRAW *
     ************/
    event EmergencyWithdraw(address token, address user, uint256 amount, uint256 balance);

    function emergencyWithdraw(address _token, uint256 _amount) public returns (bool success) {

        require(now.sub(lastActiveTransaction[msg.sender]) > inactivityReleasePeriod, "now.sub(lastActiveTransaction[msg.sender]) > inactivityReleasePeriod");
        require(tokens[_token][msg.sender] >= _amount, "not enough balance for withdrawal");

        tokens[_token][msg.sender] = tokens[_token][msg.sender].sub(_amount);

        if (_token == address(0)) {
            require(msg.sender.send(_amount), "msg.sender.send(_amount)");
        } else {
            require(Token(_token).transfer(msg.sender, _amount), "Token(_token).transfer(msg.sender, _amount)");
        }

        emit EmergencyWithdraw(_token, msg.sender, _amount, tokens[_token][msg.sender]);
        success = true;
    }

    event Withdraw(address token, address user, uint256 amount, uint256 balance);

    function adminWithdraw(address _token, uint256 _amount, address payable _user, uint256 _nonce, uint8 _v, bytes32[2] memory _rs, uint256[2] memory _fee) public onlyAdmin returns (bool success) {

         /*_fee
                [0] _feeWithdrawal
                [1] _payWithDexToken (yes is 1 - no is 0)
            _rs
                [0] _r
                [1] _s
         */


        bytes32 hash = keccak256(abi.encodePacked(_rs, _fee));	//inject HASH WITH MUL VAR LEN ARG
        require(!hashed[hash], "!hashed[hash]");
        hashed[hash] = true;

        require(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), _v, _rs[0], _rs[1]) == _user, "invalid withdraw signature");

        require(tokens[_token][_user] >= _amount, "not enough balance for withdrawal");

        tokens[_token][_user] = tokens[_token][_user].sub(_amount);

        uint256 fee;
        if (_fee[1] == 1) fee = toWei(_amount, _token).mul(_fee[0]) / 1 ether;
        if (_fee[1] == 1 && tokens[dexToken][_user] >= fee) {
            tokens[dexToken][feeAccount] = tokens[dexToken][feeAccount].add(fee);
            tokens[dexToken][_user] = tokens[dexToken][_user].sub(fee);
        } else {
            if (_fee[0] > maxFeeWithdrawal) _fee[0] = maxFeeWithdrawal;

            fee = _fee[0].mul(_amount) / 1 ether;
            tokens[_token][feeAccount] = tokens[_token][feeAccount].add(fee);
            _amount = _amount.sub(fee);
        }

        if (_token == address(0)) {
            require(_user.send(_amount), "_user.send(_amount)");
        } else {
            require(Token(_token).transfer(_user, _amount), "Token(_token).transfer(_user, _amount)");
        }

        lastActiveTransaction[_user] = now;

        emit Withdraw(_token, _user, _amount, tokens[_token][_user]);
        success = true;
  }

    function balanceOf(address _token, address _user) public view returns (uint256) {
        return tokens[_token][_user];
    }


    /***************
     * ADMIN TRADE *
     ***************/

    function adminTrade(uint256[] memory _values, address[] memory _addresses, uint8[] memory _v, bytes32[] memory _rs) public onlyAdmin returns (bool success) {
        /* amountSellTaker is in amountBuyMaker terms
         _values
            [0] amountSellTaker
            [1] tradeNonceTaker
            [2] feeTake
            [3] dexTokenPrice
            [4] feePayableDexTokenTaker (yes is 1 - no is 0)
            [5] feeMake
            [i*5+6] amountBuyMaker
            [i*5+7] amountSellMaker
            [i*5+8] expiresMaker
            [i*5+9] nonceMaker
            [i*5+10] feePayableDexTokenMaker (yes is 1 - no is 0)
         _addresses
            [0] tokenBuyAddress
            [1] tokenSellAddress
            [2] takerAddress
            [i+3] makerAddress
         _v
            [0] vTaker
            [i+1] vMaker
         _rs
            [0] rTaker
            [1] sTaker
            [i*2+2] rMaker
            [i*2+3] sMaker
         */


        /**********************
         * FEE SECURITY CHECK *
         **********************/

        //if (feeTake > maxFeeTrade) feeTake = maxFeeTrade;
        if (_values[2] > maxFeeTrade) _values[2] = maxFeeTrade;    // set max fee take

        // if (feeMake > maxFeeTrade) feeMake = maxFeeTrade;
        if (_values[5] > maxFeeTrade) _values[5] = maxFeeTrade;    // set max fee make

        /********************************
         * TAKER BEFORE SECURITY CHECK *
         ********************************/

        //check if there are sufficient funds for TAKER:
        require(tokens[_addresses[0]][_addresses[2]] >= _values[0],
                "tokens[tokenBuyAddress][takerAddress] >= amountSellTaker");

        /**************
         * LOOP LOGIC *
         **************/

        bytes32[2] memory orderHash;
        uint256[8] memory amount;
        /*
            orderHash
                [0] globalHash
                [1] makerHash
            amount
                [0] totalBuyMakerAmount
                [1] appliedAmountSellTaker
                [2] remainingAmountSellTaker
                 * [3] amountFeeMake
                 * [4] amountFeeTake
                 * [5] priceTrade
                 * [6] feeDexTokenMaker
                 * [7] feeDexTokenTaker

        */

        // remainingAmountSellTaker = amountSellTaker
        amount[2] = _values[0];

        for(uint256 i=0; i < (_values.length - 6) / 5; i++) {

            /************************
             * MAKER SECURITY CHECK *
             *************************/

            //required: nonceMaker is greater or egual makerAddress
            require(_values[i*5+9] >= invalidOrder[_addresses[i+3]],
                    "nonceMaker >= invalidOrder[makerAddress]" );

            // orderHash: ExchangeAddress, tokenBuyAddress, amountBuyMaker, tokenSellAddress, amountSellMaker, expiresMaker, nonceMaker, makerAddress, feePayableDexTokenMaker
            orderHash[1] = keccak256(abi.encodePacked(_values, _addresses, _v, _rs));	//inject HASH WITH MUL VAR LEN ARG

            //globalHash = keccak256(abi.encodePacked(globalHash, makerHash));
            orderHash[0] = keccak256(abi.encodePacked(_values, _addresses, _v, _rs));	//inject HASH WITH MUL VAR LEN ARG

            //required: the signer is the same address of makerAddress
            require(_addresses[i+3] == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", orderHash[1])), _v[i+1], _rs[i*2+2], _rs[i*2+3]),
                    'makerAddress    == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", makerHash  )), vMaker, rMaker   , sMaker   )');


            /*****************
             * GLOBAL AMOUNT *
             *****************/

            //appliedAmountSellTaker = amountBuyMaker.sub(orderFilled)
            amount[1] = _values[i*5+6].sub(orderFills[orderHash[1]]);

            //if remainingAmountSellTaker < appliedAmountSellTaker
            if (amount[2] < amount[1]) {
                //appliedAmountSellTaker = remainingAmountSellTaker
                amount[1] = amount[2];
            }

            //remainingAmountSellTaker -= appliedAmountSellTaker
            amount[2] = amount[2].sub(amount[1]);

            //totalBuyMakerAmount += appliedAmountSellTaker
            amount[0] = amount[0].add(amount[1]);


            /******************************
             * MAKER SECURITY CHECK FUNDS *
             ******************************/

            //check if there are sufficient funds for MAKER: tokens[tokenSellAddress][makerAddress] >= amountSellMaker * appliedAmountSellTaker / amountBuyMaker
            require(tokens[_addresses[1]][_addresses[i+3]] >= (_values[i*5+7].mul(amount[1]).div(_values[i*5+6])),
                    "tokens[tokenSellAddress][makerAddress] >= (amountSellMaker.mul(appliedAmountSellTaker).div(amountBuyMaker))");


            /*******************
             * FEE COMPUTATION *
             *******************/

            /* amount
                 * [3] amountFeeMake
                 * [4] amountFeeTake
                 * [5] priceTrade
                 * [6] feeDexTokenMaker
                 * [7] feeDexTokenTaker
            */

            //appliedAmountSellTaker = toWei(appliedAmountSellTaker, tokenBuyAddress);
            amount[1] = toWei(amount[1], _addresses[0]);

            //amountSellMaker = toWei(amountSellMaker, tokenSellAddress);
            _values[i*5+7] = toWei(_values[i*5+7], _addresses[1]);

            //amountBuyMaker = toWei(amountBuyMaker, tokenBuyAddress)
            _values[i*5+6] = toWei(_values[i*5+6], _addresses[0]);

            //amountFeeMake = appliedAmountSellTaker.mul(feeMake).div(1e18)
            amount[3] = amount[1].mul(_values[5]).div(1e18);
            //amountFeeTake = amountSellMaker.mul(feeTake).mul(appliedAmountSellTaker).div(amountBuyMaker) / 1e18;
            amount[4] = _values[i*5+7].mul(_values[2]).mul(amount[1]).div(_values[i*5+6]) / 1e18;

            //if (tokenBuyAddress == address(0) || (baseCurrency[tokenBuyAddress] && !(tokenSellAddress == address(0))) {
            if (_addresses[0] == address(0) || (baseCurrency[_addresses[0]] && !(_addresses[1] == address(0)))) { // maker sell order
                //amountBuyMaker is ETH or baseCurrency
                //amountSellMaker is TKN
                //amountFeeMake is ETH or baseCurrency
                //amountFeeTake is TKN

                //if (feePayableDexTokenMaker == 1) feeDexTokenMaker = amountFeeMake.mul(1e18).div(dexTokenPrice).mul(dexTokenFeeDiscount).div(1e18);
                if (_values[i*5+10] == 1) amount[6] = amount[3].mul(1e18).div(_values[3]).mul(dexTokenFeeDiscount).div(1e18);

                //if (feePayableDexTokenTaker == 1)
                if (_values[4] == 1) {
                    // priceTrade =  amountBuyMaker.mul(1e18).div(amountSellMaker)
                    amount[5] = _values[i*5+6].mul(1e18).div(_values[i*5+7]); // price is ETH / TKN
                    //feeDexTokenTaker = amountFeeTake.mul(priceTrade).div(dexTokenPrice).mul(dexTokenFeeDiscount).div(1e18);
                    amount[7] = amount[4].mul(amount[5]).div(_values[3]).mul(dexTokenFeeDiscount).div(1e18);
                }

                //amountFeeTake = fromWei(amountFeeTake, tokenSellAddress);
                amount[4] = fromWei(amount[4], _addresses[1]);

            } else { //maker buy order
                //amountBuyMaker is TKN
                //amountSellMaker is ETH or baseCurrency
                //amountFeeMake is TKN
                //amountFeeTake is ETH or baseCurrency

                //if (feePayableDexTokenTaker == 1) feeDexTokenTaker = amountFeeTake.mul(1e18).div(dexTokenPrice).mul(dexTokenFeeDiscount).div(1e18);
                if(_values[4] == 1) amount[7] = amount[4].mul(1e18).div(_values[3]).mul(dexTokenFeeDiscount).div(1e18);

                //if (feePayableDexTokenMaker == 1)
                if (_values[i*5+10] == 1) {
                    // priceTrade =  amountSellMaker.mul(1e18).div(amountBuyMaker)
                    amount[5] = _values[i*5+7].mul(1e18).div(_values[i*5+6]); // price is ETH / TKN

                    // feeDexTokenMaker = amountFeeMake.mul(priceTrade).div(dexTokenPrice).mul(dexTokenFeeDiscount).div(1e18);
                    amount[6] = amount[3].mul(amount[5]).div(_values[3]).mul(dexTokenFeeDiscount).div(1e18);
                }

                //amountFeeMake = fromWei(amountFeeMake, tokenBuyAddress);
                amount[3] = fromWei(amount[3], _addresses[0]);

            }

            //appliedAmountSellTaker = fromWei(appliedAmountSellTaker, tokenBuyAddress);
            amount[1] = fromWei(amount[1], _addresses[0]);

            //amountSellMaker = fromWei(amountSellMaker, tokenSellAddress);
            _values[i*5+7] = fromWei(_values[i*5+7], _addresses[1]);

            //amountBuyMaker = fromWei(amountBuyMaker, tokenBuyAddress)
            _values[i*5+6] = fromWei(_values[i*5+6], _addresses[0]);


            /**********************
             * FEE BALANCE UPDATE *
             **********************/

            //feePayableDexTokenTaker == 1 && tokens[dexToken][takerAddress] >= feeDexTokenTaker
            if (_values[4] == 1 && tokens[dexToken][_addresses[2]] >= amount[7] ) {

                //tokens[dexToken][takerAddress]  = tokens[dexToken][takerAddress].sub(feeDexTokenTaker);
                tokens[dexToken][_addresses[2]] = tokens[dexToken][_addresses[2]].sub(amount[7]);

                //tokens[dexToken][feeAccount] = tokens[dexToken][feeAccount].add(feeDexTokenTaker);
                tokens[dexToken][feeAccount] = tokens[dexToken][feeAccount].add(amount[7]);

                //amountFeeTake = 0;
                amount[4] = 0;
            } else {
                //tokens[tokenSellAddress][feeAccount] = tokens[tokenSellAddress][feeAccount].add(amountFeeTake);
                tokens[_addresses[1]][feeAccount] = tokens[_addresses[1]][feeAccount].add(amount[4]);
            }

            //feePayableDexTokenMaker == 1 && tokens[dexToken][makerAddress] >= feeDexTokenMaker
            if (_values[i*5+10] == 1 && tokens[dexToken][_addresses[i+3]] >= amount[6]) {

                //tokens[dexToken][makerAddress] = tokens[dexToken][makerAddress].sub(feeDexTokenMaker);
                tokens[dexToken][_addresses[i+3]] = tokens[dexToken][_addresses[i+3]].sub(amount[6]);

                //tokens[dexToken][feeAccount] = tokens[dexToken][feeAccount].add(feeDexTokenMaker);
                tokens[dexToken][feeAccount] = tokens[dexToken][feeAccount].add(amount[6]);

                //amountFeeMake = 0;
                amount[3] = 0;
            } else {
                //tokens[tokenBuyAddress][feeAccount] = tokens[tokenBuyAddress][feeAccount].add(amountFeeMake);
                tokens[_addresses[0]][feeAccount] = tokens[_addresses[0]][feeAccount].add(amount[3]);
            }


            /******************
             * BALANCE UPDATE *
             ******************/

        //tokens[tokenBuyAddress][takerAddress] = tokens[tokenBuyAddress][takerAddress].sub(appliedAmountSellTaker);
        tokens[_addresses[0]][_addresses[2]] = tokens[_addresses[0]][_addresses[2]].sub(amount[1]);

            //tokens[tokenBuyAddress][makerAddress] = tokens[tokenBuyAddress]][makerAddress].add(appliedAmountSellTaker.sub(amountFeeMake));
            tokens[_addresses[0]][_addresses[i+3]] = tokens[_addresses[0]][_addresses[i+3]].add(amount[1].sub(amount[3]));


            //tokens[tokenSellAddress][makerAddress] = tokens[tokenSellAddress][makerAddress].sub(amountSellMaker.mul(appliedAmountSellTaker).div(amountBuyMaker));
            tokens[_addresses[1]][_addresses[i+3]] = tokens[_addresses[1]][_addresses[i+3]].sub(_values[i*5+7].mul(amount[1]).div(_values[i*5+6]));

        //tokens[tokenSellAddress][takerAddress] = tokens[tokenSellAddress][takerAddress].add(amountSellMaker.mul(appliedAmountSellTaker).div(amountBuyMaker).sub(amountFeeTake));
        tokens[_addresses[1]][_addresses[2]] = tokens[_addresses[1]][_addresses[2]].add(_values[i*5+7].mul(amount[1]).div(_values[i*5+6]).sub(amount[4]));


            /***********************
             * UPDATE MAKER STATUS *
             ***********************/

            //orderFills[orderHash[1]] = orderFills[orderHash[1]].add(appliedAmountSellTaker);
            orderFills[orderHash[1]] = orderFills[orderHash[1]].add(amount[1]);

            //lastActiveTransaction[makerAddress] = now;
            lastActiveTransaction[_addresses[i+3]] = now;

        }


        /*******************************
         * TAKER AFTER SECURITY CHECK *
         *******************************/

        // tradeHash:                                   globalHash, amountSellTaker, takerAddress, tradeNonceTaker, feePayableDexTokenTaker
        bytes32 tradeHash = keccak256(abi.encodePacked(_values, _addresses, _v, _rs));	//inject HASH WITH MUL VAR LEN ARG

        //required: the signer is the same address of takerAddress
        require(_addresses[2] == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", tradeHash)), _v[0], _rs[0], _rs[1]),
                'takerAddress  == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", tradeHash)), vTaker, rTaker, sTaker)');

        //required: the same trade is not done
        require(!hashed[tradeHash], "!hashed[tradeHash] ");
        hashed[tradeHash] = true;

        //required: totalBuyMakerAmount == amountSellTaker
        require(amount[0] == _values[0], "totalBuyMakerAmount == amountSellTaker");


        /***********************
         * UPDATE TAKER STATUS *
         ***********************/

        //lastActiveTransaction[takerAddress] = now;
        lastActiveTransaction[_addresses[2]] = now;

        success = true;
    }
    function toWei(uint256 _number, address _token) internal view returns (uint256) {
        if (_token == address(0)) return _number;
        return _number.mul(1e18).div(10**uint256(Token(_token).decimals()));
    }
    function fromWei(uint256 _number, address _token) internal view returns (uint256) {
        if (_token == address(0)) return _number;
        return _number.mul(10**uint256(Token(_token).decimals())).div(1e18);
    }
}