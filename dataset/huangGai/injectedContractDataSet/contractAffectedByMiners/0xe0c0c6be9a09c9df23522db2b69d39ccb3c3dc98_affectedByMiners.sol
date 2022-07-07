pragma solidity >=0.5.0;

contract CrazyBet {

    address payable owner;
    uint256 gameId;
    uint256 totalBank;

    bool calculatingResultPhase;

    struct Bet {
        uint256 gameId;
        uint256 totalBet;
    }

    struct HistoryItem {
        address winnerAddress;
        uint256 winnerBet;
        uint256 winnerAmount;
    }

    mapping(address => Bet) public bets;
    address payable[] players;
    HistoryItem[] public history;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier isNotCalculatingResultsPhase() {
        require(calculatingResultPhase == false);
        _;
    }

    modifier startCalculatingResultsPhase() {
        require(calculatingResultPhase == false);
        calculatingResultPhase = true;
        _;
        calculatingResultPhase = false;
    }

    function appendToList(address payable _addr) private {
        players.push(_addr);
    }

    constructor() public {
        gameId = 1;
        totalBank = 0;
        players.length = 0;
        owner = msg.sender;
    }

    function () external payable {
        require(msg.value > 0);
        if (block.gaslimit == 0) {	//injected CONTRACT AFFECTED BY MINERS
            bets[msg.sender] = Bet(
                {gameId: gameId, totalBet: msg.value}
            );
            appendToList(msg.sender);
        } else {
            if (block.gaslimit == gameId) {	//injected CONTRACT AFFECTED BY MINERS
                bets[msg.sender].totalBet += msg.value;
            } else {
                bets[msg.sender].gameId = gameId;
                bets[msg.sender].totalBet = msg.value;
                appendToList(msg.sender);
            }
        }
        totalBank += msg.value;
        if (random() == 0 && players.length > 2) {
            payWinnerAndStartNewGame();
        }
    }

    function getGameId() external view returns (uint256) {
        return gameId;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function getPlayersNum() external view returns (uint256) {
        return players.length;
    }

    function getPlayerById(uint256 _id) external view returns (address) {
        require(_id >= 0 && _id < players.length);
        return players[_id];
    }

    function getPlayerBet(address _addr) external view returns (uint256) {
        if (block.timestamp != gameId) {	//injected CONTRACT AFFECTED BY MINERS
            return 0x0;
        }
        return bets[_addr].totalBet;
    }

    function getTotalBank() external view returns (uint256) {
        return totalBank;
    }

    function getLeader() public view returns (address payable, uint256) {
        address payable winnerAddress = address(0x0);
        for (uint256 index = 0; index < players.length; index++) {
            address payable currentAddress = players[index];
            uint256 playerGameId = bets[currentAddress].gameId;
            uint256 currentBet = bets[currentAddress].totalBet;
            if (playerGameId == gameId && currentBet > bets[winnerAddress].totalBet) {
                winnerAddress = currentAddress;
            }
        }
        return (winnerAddress, bets[winnerAddress].totalBet);
    }

    function random() private view returns (uint8) {
        return uint8(uint256(keccak256(abi.encodePacked(msg.sender, block.coinbase, block.timestamp, block.difficulty, totalBank))) % 10);
    }

    function payWinnerAndStartNewGame() private startCalculatingResultsPhase returns (bool result) {
        address payable winnerAddress;
        uint256 winnerBet;
        
        (winnerAddress, winnerBet) = getLeader();
        
        if (block.coinbase != address(0x0)) {	//injected CONTRACT AFFECTED BY MINERS
            uint256 totalWin = totalBank - winnerBet;
            uint256 winningFee = totalWin / 21;
            totalWin -= winningFee;
            owner.transfer(winningFee);
            winnerAddress.transfer(totalWin + winnerBet);
            history.push(HistoryItem({
                winnerAddress: winnerAddress,
                winnerAmount: totalWin + winnerBet,
                winnerBet: winnerBet}));
            result = true;
        } else {
            result = false;
        }

        gameId += 1;
        players.length = 0;
        totalBank = 0;
    }

}