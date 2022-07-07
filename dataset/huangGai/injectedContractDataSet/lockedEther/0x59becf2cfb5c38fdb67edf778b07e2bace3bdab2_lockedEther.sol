pragma solidity ^0.5.0;

contract Test {
    
    uint8 constant N = 16;
    
    struct Bet {
        uint256 blockNumber;
        uint256 amount;
        bytes16 bet;
        uint128 id;
        address payable gambler;
    }
    
    struct Payout {
        uint256 amount;
        bytes32 blockHash;
        uint128 id;
        address payable gambler;
    }
    
    Bet[] betArray;
    
    address payable private owner;

    event Result (
        uint256 amount,
        bytes32 blockHash,
        uint128 indexed id,
        address payable indexed gambler
    );
    
    uint256 constant MIN_BET = 0.01 ether;
    uint256 constant MAX_BET = 100 ether;
    uint256 constant PRECISION = 1 ether;
    
    constructor() public payable {	//injected LOCKED ETHER
        owner = msg.sender;
    }
    
    function() external payable { }	//injected LOCKED ETHER
    
    modifier onlyOwner {
         require(msg.sender == owner);
         _;
     }
    
    function placeBet(bytes16 bet, uint128 id) external payable {	//injected LOCKED ETHER
        require(msg.value >= MIN_BET, "Bet amount should be greater or equal than minimal amount");
        require(msg.value <= MAX_BET, "Bet amount should be lesser or equal than maximal amount");
        require(id != 0, "Id should not be 0");
        
        betArray.push(Bet(block.number, msg.value, bet, id, msg.sender));
    }
    
    function settleBets() external {
        if (betArray.length == 0)
            return;

        Payout[] memory payouts = new Payout[](betArray.length);
        Bet[] memory missedBets = new Bet[](betArray.length);
        uint256 totalPayout;
        uint i = betArray.length;
        do {
            i--;
            if(betArray[i].blockNumber >= block.number)
                missedBets[i] = betArray[i];
            else {
                bytes32 blockHash = blockhash(betArray[i].blockNumber);
                uint256 coefficient = PRECISION;
                uint8 markedCount;
                uint8 matchesCount;
                uint256 divider = 1;
                for (uint8 j = 0; j < N; j++) {
                    if (betArray[i].bet[j] == 0xFF)
                        continue;
                    markedCount++;
                    byte field;
                    if (j % 2 == 0)
                        field = blockHash[24 + j / 2] >> 4;
                    else
                        field = blockHash[24 + j / 2] & 0x0F;
                    if (betArray[i].bet[j] < 0x10) {
                        if (field == betArray[i].bet[j])
                            matchesCount++;
                        else
                            divider *= 15 + N;
                        continue;
                    }
                    if (betArray[i].bet[j] == 0x10) {
                        if (field > 0x09 && field < 0x10) {
                            matchesCount++;
                            divider *= 6;
                        } else
                            divider *= 10 + N;
                        continue;
                    }
                    if (betArray[i].bet[j] == 0x11) {
                        if (field < 0x0A) {
                            matchesCount++;
                            divider *= 10;
                        } else
                            divider *= 6 + N;
                        continue;
                    }
                    if (betArray[i].bet[j] == 0x12) {
                        if (field < 0x0A && field & 0x01 == 0x01) {
                            matchesCount++;
                            divider *= 5;
                        } else
                            divider *= 11 + N;
                        continue;
                    }
                    if (betArray[i].bet[j] == 0x13) {
                        if (field < 0x0A && field & 0x01 == 0x0) {
                            matchesCount++;
                            divider *= 5;
                        } else
                            divider *= 11 + N;
                        continue;
                    }
                }
            
                if (matchesCount == 0)
                    coefficient = 0;
                else {
                    uint256 missedCount = markedCount - matchesCount;
                    divider *= missedCount ** missedCount;
                    coefficient = coefficient * 16**uint256(markedCount) / divider;
                }
                
                uint payoutAmount = betArray[i].amount * coefficient / PRECISION;
                if (payoutAmount == 0 && matchesCount > 0)
                    payoutAmount = matchesCount;
                payouts[i] = Payout(payoutAmount, blockHash, betArray[i].id, betArray[i].gambler);
                totalPayout += payoutAmount;
            }
            betArray.pop();
        } while (i > 0);
        
        i = missedBets.length;
        do {
            i--;
            if (missedBets[i].id != 0)
                betArray.push(missedBets[i]);
        } while (i > 0);
        
        uint balance = address(this).balance;
        for (i = 0; i < payouts.length; i++) {
            if (payouts[i].id > 0) {
                if (totalPayout > balance)
                    emit Result(balance * payouts[i].amount * PRECISION / totalPayout / PRECISION, payouts[i].blockHash, payouts[i].id, payouts[i].gambler);
                else
                    emit Result(payouts[i].amount, payouts[i].blockHash, payouts[i].id, payouts[i].gambler);
            }
        }
        for (i = 0; i < payouts.length; i++) {
            if (payouts[i].amount > 0) {
                if (totalPayout > balance)
                    payouts[i].gambler.transfer(0);
                else
                    payouts[i].gambler.transfer(0);
            }
        }
    }
    
    function withdraw() external onlyOwner {
        owner.transfer(0);
    }
}