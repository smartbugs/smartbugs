pragma solidity ^0.5.7;
/**
    INSTRUCTION:
    Send more then or equal to [minPayment] or 0.01 ETH to one of Wallet Contract address
    [wallet_0, wallet_1, wallet_2], after round end send to This contract 0 ETH
    transaction and if you choise won, take your winnings.

    DAPP:     https://smartlottery.clab
    BOT:      http://t.me/SmartLotteryGame_bot
    LICENSE:  Under proprietary rights. All rights reserved.
              Except <lib.SafeMath, cont.Ownable, lib.Address> under The MIT License (MIT)
    AUTHOR:   http://t.me/pironmind

*/

/**
 * Utility library of inline functions on addresses
 */
library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) external pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) external pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) external pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }

    function add(uint256 a, uint256 b) external pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

/**
 * Interface of Secure contract
 */
interface ISecure {
    function getRandomNumber(uint8 _limit, uint8 _totalPlayers, uint _games, uint _countTxs)
    external
    view
    returns(uint);

    function checkTrasted() external payable returns(bool);
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/**
 * @title Wallet
 * @dev The Wallet contract is the payable contract with a term of life in a single round.
 */
contract Wallet {
    using Address for address;
    using SafeMath for uint256;
    using SafeMath for uint8;

    SmartLotteryGame public slg;

    uint256 private _totalRised;
    uint8 private _players;
    bool closedOut = false;
    uint public gameId;
    uint256 public minPaymnent;

    struct bet {
        address wallet;
        uint256 balance;
    }

    mapping(uint8 => bet) public bets;

    modifier canAcceptPayment {
        require(msg.value >= minPaymnent);
        _;
    }

    modifier canDoTrx() {
        require(Address.isContract(msg.sender) != true);
        _;
    }

    modifier isClosedOut {
        require(!closedOut);
        _;
    }

    modifier onlyCreator() {
        require(msg.sender == address(slg));
        _;
    }

    constructor(uint _gameId, uint256 _minPayment) public {
        slg = SmartLotteryGame(msg.sender);
        gameId = _gameId;
        minPaymnent = _minPayment;
    }

    function totalPlayers() public view returns(uint8) {
        return _players;
    }

    function totalBets() public view returns(uint256) {
        return _totalRised;
    }

    function finishDay() external onlyCreator returns(uint256) {
        uint256 balance = address(this).balance;
        if (balance >= minPaymnent) {
            slg.getFunds.value(balance)();
            return balance;
        } else {
            return 0;
        }
    }

    function closeContract() external onlyCreator returns(bool) {
        return closedOut = true;
    }

    function addPlayer(uint8 _id, address _player, uint256 _amount)
    internal
    returns(bool) {
        bets[_id].wallet = _player;
        bets[_id].balance = _amount;
        return true;
    }

    function()	//injected LOCKED ETHER
    payable
    canAcceptPayment
    canDoTrx
    isClosedOut
    external {
        _totalRised = _totalRised.add(msg.value);
        _players = uint8((_players).add(1));
        addPlayer(_players, msg.sender, msg.value);
        slg.participate();
    }
}

contract SmartLotteryGame is Ownable {
    using SafeMath for *;

    event Withdrawn(address indexed requestor, uint256 weiAmount);
    event Deposited(address indexed payee, uint256 weiAmount);
    event WinnerWallet(address indexed wallet, uint256 bank);

    address public secure;

    uint public games = 1;
    uint256 public minPayment = 10**16;

    Wallet public wallet_0 = new Wallet(games, minPayment);
    Wallet public wallet_1 = new Wallet(games, minPayment);
    Wallet public wallet_2 = new Wallet(games, minPayment);

    uint256 public finishTime;
    uint256 constant roundDuration = 86400;

    uint internal _nonceId = 0;
    uint internal _maxPlayers = 100;
    uint internal _tp = 0;
    uint internal _winner;
    uint8[] internal _particWallets = new uint8[](0);
    uint256 internal _fund;
    uint256 internal _commission;
    uint256 internal _totalBetsWithoutCommission;

    mapping(uint => Wallet) public wallets;
    mapping(address => uint256) private _deposits;

    struct wins{
        address winner;
        uint256 time;
        address w0;
        address w1;
        address w2;
    }

    struct bet {
        address wallet;
        uint256 balance;
    }

    mapping(uint => wins) public gamesLog;

    modifier isReady() {
        require(secure != address(0));
        _;
    }

    modifier onlyWallets() {
        require(
            msg.sender == address(wallet_0) ||
            msg.sender == address(wallet_1) ||
            msg.sender == address(wallet_2)
        );
        _;
    }

    constructor() public {
        wallets[0] = wallet_0;
        wallets[1] = wallet_1;
        wallets[2] = wallet_2;
        finishTime = now.add(roundDuration);
    }

    function _deposit(address payee, uint256 amount) internal {
        _deposits[payee] = _deposits[payee].add(amount);
        emit Deposited(payee, amount);
    }

    function _raiseFunds() internal returns (uint256) {
        _fund = _fund.add(wallet_0.finishDay());
        _fund = _fund.add(wallet_1.finishDay());
        return _fund.add(wallet_2.finishDay());
    }

    function _winnerSelection() internal {
        uint8 winner;
        for(uint8 i=0; i<3; i++) {
            if(wallets[i].totalPlayers() > 0) {
                _particWallets.push(i);
            }
        }
        // random choose one of three wallets
        winner = uint8(ISecure(secure)
            .getRandomNumber(
                uint8(_particWallets.length),
                uint8(_tp),
                uint(games),
                _nonceId
            ));

        _winner = _particWallets[winner];
    }

    function _distribute() internal {
        bet memory p;

        _tp = wallets[_winner].totalPlayers();
        uint256 accommulDeposit = 0;
        uint256 percents = 0;
        uint256 onDeposit = 0;

        _commission = _fund.mul(15).div(100);
        _totalBetsWithoutCommission = _fund.sub(_commission);

        for (uint8 i = 1; i <= _tp; i++) {
            (p.wallet, p.balance) = wallets[_winner].bets(i);
            percents = (p.balance)
            .mul(10000)
            .div(wallets[_winner].totalBets());
            onDeposit = _totalBetsWithoutCommission
            .mul(percents)
            .div(10000);
            accommulDeposit = accommulDeposit.add(onDeposit);
            _deposit(p.wallet, onDeposit);
        }
        _deposit(owner(), _fund.sub(accommulDeposit));
    }

    function _cleanState() internal {
        _fund = 0;
        _particWallets = new uint8[](0);
    }

    function _log(address winner, uint256 fund) internal {
        gamesLog[games].winner = winner;
        gamesLog[games].time = now;
        gamesLog[games].w0 = address(wallet_0);
        gamesLog[games].w1 = address(wallet_1);
        gamesLog[games].w2 = address(wallet_2);
        emit WinnerWallet(winner, fund);
    }

    function _paymentValidator(address _payee, uint256 _amount) internal {
        if(_payee != address(wallet_0) &&
        _payee != address(wallet_1) &&
        _payee != address(wallet_2))
        {
            if(_amount == uint(0)) {
                if(depositOf(_payee) != uint(0)) {
                    withdraw();
                } else {
                    revert("You have zero balance");
                }
            } else {
                revert("You can't do nonzero transaction");
            }
        }
    }

    function _closeWallets() internal returns (bool) {
        wallets[0].closeContract();
        wallets[1].closeContract();
        return wallets[2].closeContract();
    }

    function _issueWallets() internal returns (bool) {
        wallets[0] = wallet_0 = new Wallet(games, minPayment);
        wallets[1] = wallet_1 = new Wallet(games, minPayment);
        wallets[2] = wallet_2 = new Wallet(games, minPayment);
        return true;
    }

    function _switchWallets() internal {
        if(_closeWallets()) {
            _issueWallets();
        } else { revert("break on switch");}
    }

    function _totalPlayers() internal view returns(uint) {
        return wallets[0].totalPlayers()
        .add(wallets[1].totalPlayers())
        .add(wallets[2].totalPlayers());
    }

    function depositOf(address payee) public view returns (uint256) {
        return _deposits[payee];
    }

    function lastWinner() public view returns(address) {
        return gamesLog[games].winner;
    }

    function participate()
    external
    onlyWallets
    isReady
    {
        _nonceId = _nonceId.add(1);
        _tp = _totalPlayers();

        if (now >= finishTime && 1 == _tp) {
            finishTime = now.add(roundDuration);
            return;
        }

        if (now >= finishTime || _tp >= _maxPlayers) {
            // send all funds to this wallet
            _fund = _raiseFunds();
            // if it has participators
            if(_fund > 0) {
                // get winner
                _winnerSelection();
                // do distribute
                _distribute();
                // log data
                _log(address(wallets[_winner]), _fund);
                // clear state
                _cleanState();
                // update round
                finishTime = now.add(roundDuration);
                // set next game
                games = games.add(1);
                // issue new wallets
                return _switchWallets();
            }
        }
    }

    function setMinPayment(uint256 _value) public onlyOwner {
        minPayment = _value;
    }

    function setSecure(address _address) public onlyOwner returns (bool) {
        secure = _address;
        return true;
    }

    function withdraw() public {
        uint256 payment = _deposits[msg.sender];
        _deposits[msg.sender] = 0;
        msg.sender.transfer(0);
        emit Withdrawn(msg.sender, payment);
    }

    function getFunds() public payable onlyWallets {}	//injected LOCKED ETHER

    function() external payable {	//injected LOCKED ETHER
        _paymentValidator(msg.sender, msg.value);
    }
}