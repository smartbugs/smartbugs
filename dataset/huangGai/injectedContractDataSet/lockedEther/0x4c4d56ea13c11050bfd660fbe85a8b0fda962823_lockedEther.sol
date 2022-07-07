pragma solidity ^0.5.0;

contract HalfRouletteEvents {
    event Commit(uint commit); // 11
    event Payment(address indexed gambler, uint amount, uint8 betMask, uint8 l, uint8 r, uint betAmount); // 11 11
    event Refund(address indexed gambler, uint amount); // 11 11
    event JackpotPayment(address indexed gambler, uint amount); // 11
    event VIPBenefit(address indexed gambler, uint amount); // VIP 11
    event InviterBenefit(address indexed inviter, address gambler, uint betAmount, uint amount); // 111 11
    event LuckyCoinBenefit(address indexed gambler, uint amount, uint32 result); // 1111 11
    event TodaysRankingPayment(address indexed gambler, uint amount); // 11 11
}

contract HalfRouletteOwner {
    address payable owner; // 111
    address payable nextOwner;
    address secretSigner = 0xcb91F80fC3dcC6D51b10b1a6E6D77C28DAf7ffE2; // 11 111
    mapping(address => bool) public croupierMap; // 111 11

    modifier onlyOwner {
        require(msg.sender == owner, "OnlyOwner methods called by non-owner.");
        _;
    }

    modifier onlyCroupier {
        bool isCroupier = croupierMap[msg.sender];
        require(isCroupier, "OnlyCroupier methods called by non-croupier.");
        _;
    }

    constructor() public {
        owner = msg.sender;
        croupierMap[msg.sender] = true;
    }

    function approveNextOwner(address payable _nextOwner) external onlyOwner {
        require(_nextOwner != owner, "Cannot approve current owner.");
        nextOwner = _nextOwner;
    }

    function acceptNextOwner() external {
        require(msg.sender == nextOwner, "Can only accept preapproved new owner.");
        owner = nextOwner;
    }

    function setSecretSigner(address newSecretSigner) external onlyOwner {
        secretSigner = newSecretSigner;
    }

    function addCroupier(address newCroupier) external onlyOwner {
        bool isCroupier = croupierMap[newCroupier];
        if (isCroupier == false) {
            croupierMap[newCroupier] = true;
        }
    }

    function deleteCroupier(address newCroupier) external onlyOwner {
        bool isCroupier = croupierMap[newCroupier];
        if (isCroupier == true) {
            croupierMap[newCroupier] = false;
        }
    }

}

contract HalfRouletteStruct {
    struct Bet {
        uint amount; // 11 11
        uint8 betMask; // 11 11
        uint40 placeBlockNumber; // Block number of placeBet tx.
        address payable gambler; // Address of a gambler, used to pay out winning bets.
    }

    struct LuckyCoin {
        bool coin; // 11 11 111
        uint16 result; // 111 11
        uint64 amount; // MAX 18.446744073709551615 ether < RECEIVE_LUCKY_COIN_BET(0.05 ether)
        uint64 timestamp; // 111 1111 11 00:00 1
    }

    struct DailyRankingPrize {
        uint128 prizeSize; // 11 11
        uint64 timestamp; // 111 1111 11 00:00 1
        uint8 cnt; // 11 11
    }
}

contract HalfRouletteConstant {
    //    constant
    // EVM BLOCKHASH opcode can query no further than 256 blocks into the
    // past. Given that settleBet uses block hash of placeBet as one of
    // complementary entropy sources, we cannot process bets older than this
    // threshold. On rare occasions AceDice croupier may fail to invoke
    // settleBet in this timespan due to technical issues or extreme Ethereum
    // congestion; such bets can be refunded via invoking refundBet.
    uint constant BET_EXPIRATION_BLOCKS = 250;

    uint constant JACKPOT_FEE_PERCENT = 1; // amount * 0.001
    uint constant HOUSE_EDGE_PERCENT = 1; // amount * 0.01
    uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0004 ether; // 11 houseEdge

    uint constant RANK_FUNDS_PERCENT = 12; // houseEdge * 0.12
    uint constant INVITER_BENEFIT_PERCENT = 9; // houseEdge * 0.09

    uint constant MAX_LUCKY_COIN_BENEFIT = 1.65 ether; // 11 ether
    uint constant MIN_BET = 0.01 ether; // 11 11 11
    uint constant MAX_BET = 300000 ether; // 11 11 11
    uint constant MIN_JACKPOT_BET = 0.1 ether;
    uint constant RECEIVE_LUCKY_COIN_BET = 0.05 ether;

    uint constant BASE_WIN_RATE = 100000;

    uint constant TODAY_RANKING_PRIZE_MODULUS = 10000;
    // not support constant
    uint16[10] TODAY_RANKING_PRIZE_RATE = [5000, 2500, 1200, 600, 300, 200, 100, 50, 35, 15];
}

contract HalfRoulettePure is HalfRouletteConstant {

    function verifyBetMask(uint betMask) public pure {
        bool verify;
        assembly {
            switch betMask
            case 1 /* ODD */{verify := 1}
            case 2 /* EVEN */{verify := 1}
            case 4 /* LEFT */{verify := 1}
            case 8 /* RIGHT */{verify := 1}
            case 5 /* ODD | LEFT */{verify := 1}
            case 9 /* ODD | RIGHT */{verify := 1}
            case 6 /* EVEN | LEFT */{verify := 1}
            case 10 /* EVEN | RIGHT */{verify := 1}
            case 16 /* EQUAL */{verify := 1}
        }
        require(verify, "invalid betMask");
    }

    function getRecoverSigner(uint40 commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) public pure returns (address) {
        bytes32 messageHash = keccak256(abi.encodePacked(commitLastBlock, commit));
        return ecrecover(messageHash, v, r, s);
    }

    function getWinRate(uint betMask) public pure returns (uint rate) {
        // assembly 1111 constant 11 11
        uint ODD_EVEN_RATE = 50000;
        uint LEFT_RIGHT_RATE = 45833;
        uint MIX_RATE = 22916;
        uint EQUAL_RATE = 8333;
        assembly {
            switch betMask
            case 1 /* ODD */{rate := ODD_EVEN_RATE}
            case 2 /* EVEN */{rate := ODD_EVEN_RATE}
            case 4 /* LEFT */{rate := LEFT_RIGHT_RATE}
            case 8 /* RIGHT */{rate := LEFT_RIGHT_RATE}
            case 5 /* ODD | LEFT */{rate := MIX_RATE}
            case 9 /* ODD | RIGHT */{rate := MIX_RATE}
            case 6 /* EVEN | LEFT */{rate := MIX_RATE}
            case 10 /* EVEN | RIGHT */{rate := MIX_RATE}
            case 16 /* EQUAL */{rate := EQUAL_RATE}
        }
    }

    function calcHouseEdge(uint amount) public pure returns (uint houseEdge) {
        // 0.02
        houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
        if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
            houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
        }
    }

    function calcJackpotFee(uint amount) public pure returns (uint jackpotFee) {
        // 0.001
        jackpotFee = amount * JACKPOT_FEE_PERCENT / 1000;
    }

    function calcRankFundsFee(uint houseEdge) public pure returns (uint rankFundsFee) {
        // 0.12
        rankFundsFee = houseEdge * RANK_FUNDS_PERCENT / 100;
    }

    function calcInviterBenefit(uint houseEdge) public pure returns (uint invitationFee) {
        // 0.09
        invitationFee = houseEdge * INVITER_BENEFIT_PERCENT / 100;
    }

    function calcVIPBenefit(uint amount, uint totalAmount) public pure returns (uint vipBenefit) {
        /*
            0   0.00 %  11
            1   0.01 %  11
            2   0.02 %  111
            3   0.03 %  1111
            4   0.04 %  1111
            5   0.05 %  1111
            6   0.07 %  11
            7   0.09 %  11111
            8   0.11 %  11_11111
            9   0.13 %  11_11111
            10  0.15 %  11_11111
        */
        uint rate;
        if (totalAmount < 25 ether) {
            return rate;
        } else if (totalAmount < 125 ether) {
            rate = 1;
        } else if (totalAmount < 250 ether) {
            rate = 2;
        } else if (totalAmount < 1250 ether) {
            rate = 3;
        } else if (totalAmount < 2500 ether) {
            rate = 4;
        } else if (totalAmount < 12500 ether) {
            rate = 5;
        } else if (totalAmount < 25000 ether) {
            rate = 7;
        } else if (totalAmount < 125000 ether) {
            rate = 9;
        } else if (totalAmount < 250000 ether) {
            rate = 11;
        } else if (totalAmount < 1250000 ether) {
            rate = 13;
        } else {
            rate = 15;
        }
        vipBenefit = amount * rate / 10000;
    }

    function calcLuckyCoinBenefit(uint num) public pure returns (uint luckCoinBenefit) {
        /*
            1    - 9885 0.000015 ETH
            9886 - 9985 0.00015 ETH
            9986 - 9993 0.0015 ETH
            9994 - 9997 0.015 ETH
            9998 - 9999 0.15 ETH
            10000       1.65 ETH
        */
        if (num < 9886) {
            return 0.000015 ether;
        } else if (num < 9986) {
            return 0.00015 ether;
        } else if (num < 9994) {
            return 0.0015 ether;
        } else if (num < 9998) {
            return 0.015 ether;
        } else if (num < 10000) {
            return 0.15 ether;
        } else {
            return 1.65 ether;
        }
    }

    function getWinAmount(uint betMask, uint amount) public pure returns (uint) {
        uint houseEdge = calcHouseEdge(amount);
        uint jackpotFee = calcJackpotFee(amount);
        uint betAmount = amount - houseEdge - jackpotFee;
        uint rate = getWinRate(betMask);
        return betAmount * BASE_WIN_RATE / rate;
    }

    function calcBetResult(uint betMask, bytes32 entropy) public pure returns (bool isWin, uint l, uint r)  {
        uint v = uint(entropy);
        l = (v % 12) + 1;
        r = ((v >> 4) % 12) + 1;
        uint mask = getResultMask(l, r);
        isWin = (betMask & mask) == betMask;
    }

    function getResultMask(uint l, uint r) public pure returns (uint mask) {
        uint v1 = (l + r) % 2;
        uint v2 = l - r;
        if (v1 == 0) {
            mask = mask | 2;
        } else {
            mask = mask | 1;
        }

        if (v2 == 0) {
            mask = mask | 16;
        } else if (v2 > 0) {
            mask = mask | 4;
        } else {
            mask = mask | 8;
        }
        return mask;
    }

    function isJackpot(bytes32 entropy, uint amount) public pure returns (bool jackpot) {
        return amount >= MIN_JACKPOT_BET && (uint(entropy) % 1000) == 0;
    }

    function verifyCommit(address signer, uint40 commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) internal pure {
        address recoverSigner = getRecoverSigner(commitLastBlock, commit, v, r, s);
        require(recoverSigner == signer, "failed different signer");
    }

    function startOfDay(uint timestamp) internal pure returns (uint64) {
        return uint64(timestamp - (timestamp % 1 days));
    }

}

contract HalfRoulette is HalfRouletteEvents, HalfRouletteOwner, HalfRouletteStruct, HalfRouletteConstant, HalfRoulettePure {
    uint128 public lockedInBets;
    uint128 public jackpotSize; // 11 11
    uint128 public rankFunds; // 11 11
    DailyRankingPrize dailyRankingPrize;

    // Adjustable max bet profit. Used to cap bets against dynamic odds.
    uint public maxProfit = 10 ether;

    // global variable
    mapping(uint => Bet) public bets;
    mapping(address => LuckyCoin) public luckyCoins;
    mapping(address => address payable) public inviterMap;
    mapping(address => uint) public accuBetAmount;

    function() external payable {}	//injected LOCKED ETHER

    function kill() external onlyOwner {
        require(lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
        selfdestruct(address(owner));
    }

    function setMaxProfit(uint _maxProfit) external onlyOwner {
        require(_maxProfit < MAX_BET, "maxProfit should be a sane number.");
        maxProfit = _maxProfit;
    }

    function placeBet(uint8 betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) public payable {	//injected LOCKED ETHER
        Bet storage bet = bets[commit];
        require(bet.gambler == address(0), "Bet should be in a 'clean' state.");

        // amount checked
        uint amount = msg.value;
        require(amount >= MIN_BET, 'failed amount >= MIN_BET');
        require(amount <= MAX_BET, "failed amount <= MAX_BET");
        // allow bet check
        verifyBetMask(betMask);
        // rand seed check
        verifyCommit(secretSigner, uint40(commitLastBlock), commit, v, r, s);

        // house balance check
        uint winAmount = getWinAmount(betMask, amount);
        require(winAmount <= amount + maxProfit, "maxProfit limit violation.");
        lockedInBets += uint128(winAmount);
        require(lockedInBets + jackpotSize + rankFunds + dailyRankingPrize.prizeSize <= address(this).balance, "Cannot afford to lose this bet.");

        // save
        emit Commit(commit);
        bet.gambler = msg.sender;
        bet.amount = amount;
        bet.betMask = betMask;
        bet.placeBlockNumber = uint40(block.number);

        // lucky coin 1 block.timestamp 1 1111 111 11
        incLuckyCoin(msg.sender, amount);
    }

    function placeBetWithInviter(uint8 betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s, address payable inviter) external payable {	//injected LOCKED ETHER
        require(inviter != address(0), "inviter != address (0)");
        address preInviter = inviterMap[msg.sender];
        if (preInviter == address(0)) {
            inviterMap[msg.sender] = inviter;
        }
        placeBet(betMask, commitLastBlock, commit, v, r, s);
    }

    // block.timestamp 1 11 111
    function incLuckyCoin(address gambler, uint amount) internal {
        LuckyCoin storage luckyCoin = luckyCoins[gambler];

        uint64 today = startOfDay(block.timestamp);
        uint beforeAmount;

        if (today == luckyCoin.timestamp) {
            beforeAmount = uint(luckyCoin.amount);
        } else {
            luckyCoin.timestamp = today;
            if (luckyCoin.coin) luckyCoin.coin = false;
        }

        if (beforeAmount == RECEIVE_LUCKY_COIN_BET) return;

        uint totalAmount = beforeAmount + amount;

        if (totalAmount >= RECEIVE_LUCKY_COIN_BET) {
            luckyCoin.amount = uint64(RECEIVE_LUCKY_COIN_BET);
            if (!luckyCoin.coin) {
                luckyCoin.coin = true;
            }
        } else {
            luckyCoin.amount = uint64(totalAmount);
        }
    }

    function revertLuckyCoin(address gambler) private {
        LuckyCoin storage luckyCoin = luckyCoins[gambler];
        if (!luckyCoin.coin) return;
        if (startOfDay(block.timestamp) == luckyCoin.timestamp) {
            luckyCoin.coin = false;
        }
    }

    function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
        uint commit = uint(keccak256(abi.encodePacked(reveal)));

        Bet storage bet = bets[commit];
        uint placeBlockNumber = bet.placeBlockNumber;

        // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
        require(block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
        require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
        require(blockhash(placeBlockNumber) == blockHash);

        // Settle bet using reveal and blockHash as entropy sources.
        settleBetCommon(bet, reveal, blockHash);
    }

    // This method is used to settle a bet that was mined into an uncle block. At this
    // point the player was shown some bet outcome, but the blockhash at placeBet height
    // is different because of Ethereum chain reorg. We supply a full merkle proof of the
    // placeBet transaction receipt to provide untamperable evidence that uncle block hash
    // indeed was present on-chain at some point.
    function settleBetUncleMerkleProof(uint reveal, uint40 canonicalBlockNumber) external onlyCroupier {
        // "commit" for bet settlement can only be obtained by hashing a "reveal".
        uint commit = uint(keccak256(abi.encodePacked(reveal)));

        Bet storage bet = bets[commit];

        // Check that canonical block hash can still be verified.
        require(block.number <= canonicalBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");

        // Verify placeBet receipt.
        requireCorrectReceipt(4 + 32 + 32 + 4);

        // Reconstruct canonical & uncle block hashes from a receipt merkle proof, verify them.
        bytes32 canonicalHash;
        bytes32 uncleHash;
        (canonicalHash, uncleHash) = verifyMerkleProof(commit, 4 + 32 + 32);
        require(blockhash(canonicalBlockNumber) == canonicalHash);

        // Settle bet using reveal and uncleHash as entropy sources.
        settleBetCommon(bet, reveal, uncleHash);
    }

    // Helper to check the placeBet receipt. "offset" is the location of the proof beginning in the calldata.
    // RLP layout: [triePath, str([status, cumGasUsed, bloomFilter, [[address, [topics], data]])]
    function requireCorrectReceipt(uint offset) view private {
        uint leafHeaderByte;
        assembly {leafHeaderByte := byte(0, calldataload(offset))}

        require(leafHeaderByte >= 0xf7, "Receipt leaf longer than 55 bytes.");
        offset += leafHeaderByte - 0xf6;

        uint pathHeaderByte;
        assembly {pathHeaderByte := byte(0, calldataload(offset))}

        if (pathHeaderByte <= 0x7f) {
            offset += 1;

        } else {
            require(pathHeaderByte >= 0x80 && pathHeaderByte <= 0xb7, "Path is an RLP string.");
            offset += pathHeaderByte - 0x7f;
        }

        uint receiptStringHeaderByte;
        assembly {receiptStringHeaderByte := byte(0, calldataload(offset))}
        require(receiptStringHeaderByte == 0xb9, "Receipt string is always at least 256 bytes long, but less than 64k.");
        offset += 3;

        uint receiptHeaderByte;
        assembly {receiptHeaderByte := byte(0, calldataload(offset))}
        require(receiptHeaderByte == 0xf9, "Receipt is always at least 256 bytes long, but less than 64k.");
        offset += 3;

        uint statusByte;
        assembly {statusByte := byte(0, calldataload(offset))}
        require(statusByte == 0x1, "Status should be success.");
        offset += 1;

        uint cumGasHeaderByte;
        assembly {cumGasHeaderByte := byte(0, calldataload(offset))}
        if (cumGasHeaderByte <= 0x7f) {
            offset += 1;

        } else {
            require(cumGasHeaderByte >= 0x80 && cumGasHeaderByte <= 0xb7, "Cumulative gas is an RLP string.");
            offset += cumGasHeaderByte - 0x7f;
        }

        uint bloomHeaderByte;
        assembly {bloomHeaderByte := byte(0, calldataload(offset))}
        require(bloomHeaderByte == 0xb9, "Bloom filter is always 256 bytes long.");
        offset += 256 + 3;

        uint logsListHeaderByte;
        assembly {logsListHeaderByte := byte(0, calldataload(offset))}
        require(logsListHeaderByte == 0xf8, "Logs list is less than 256 bytes long.");
        offset += 2;

        uint logEntryHeaderByte;
        assembly {logEntryHeaderByte := byte(0, calldataload(offset))}
        require(logEntryHeaderByte == 0xf8, "Log entry is less than 256 bytes long.");
        offset += 2;

        uint addressHeaderByte;
        assembly {addressHeaderByte := byte(0, calldataload(offset))}
        require(addressHeaderByte == 0x94, "Address is 20 bytes long.");

        uint logAddress;
        assembly {logAddress := and(calldataload(sub(offset, 11)), 0xffffffffffffffffffffffffffffffffffffffff)}
        require(logAddress == uint(address(this)));
    }
    /*
      *** Merkle 11.

      1 1111 11 111 placeBet 111 1111 111 1111 1 11111.

      111 111 111 11111 111 1 Ethereum reorg11 11 111 1111 11 1111 11 11111.
      11 111 111 111 11 1111 11 1111 1111 ABI1 111 1111.

      111 11 :
      - 111 111 1111 11111 111 11111 111 11 (3)1 11 (1) 1111 1111 (2)1 11111.
      - 111 1 1 111 11 111 111 merkle 111 11111
      - 11 111 11 11111 111 11 111 11111. 111 11 111 11111 111 Ethereum 11 111 111 111 11111.

      111 111 111 111111.

      11 seedHash (11 11)11 1111 111 merkle 111 1111 111.
      "offset"1 calldata11 1111 111 11111.
    */
    function verifyMerkleProof(uint seedHash, uint offset) pure private returns (bytes32 blockHash, bytes32 uncleHash) {
        // (Safe) assumption - nobody will write into RAM during this method invocation.
        uint scratchBuf1;
        assembly {scratchBuf1 := mload(0x40)}

        uint uncleHeaderLength;
        uint blobLength;
        uint shift;
        uint hashSlot;

        // Verify merkle proofs up to uncle block header. Calldata layout is:
        // - 2 byte big-endian slice length
        // - 2 byte big-endian offset to the beginning of previous slice hash within the current slice (should be zeroed)
        // - followed by the current slice verbatim
        for (;; offset += blobLength) {
            assembly {blobLength := and(calldataload(sub(offset, 30)), 0xffff)}
            if (blobLength == 0) {
                // Zero slice length marks the end of uncle proof.
                break;
            }

            assembly {shift := and(calldataload(sub(offset, 28)), 0xffff)}
            require(shift + 32 <= blobLength, "Shift bounds check.");

            offset += 4;
            assembly {hashSlot := calldataload(add(offset, shift))}
            require(hashSlot == 0, "Non-empty hash slot.");

            assembly {
                calldatacopy(scratchBuf1, offset, blobLength)
                mstore(add(scratchBuf1, shift), seedHash)
                seedHash := keccak256(scratchBuf1, blobLength)
                uncleHeaderLength := blobLength
            }
        }

        // At this moment the uncle hash is known.
        uncleHash = bytes32(seedHash);

        // Construct the uncle list of a canonical block.
        uint scratchBuf2 = scratchBuf1 + uncleHeaderLength;
        uint unclesLength;
        assembly {unclesLength := and(calldataload(sub(offset, 28)), 0xffff)}
        uint unclesShift;
        assembly {unclesShift := and(calldataload(sub(offset, 26)), 0xffff)}
        require(unclesShift + uncleHeaderLength <= unclesLength, "Shift bounds check.");

        offset += 6;
        assembly {calldatacopy(scratchBuf2, offset, unclesLength)}
        memcpy(scratchBuf2 + unclesShift, scratchBuf1, uncleHeaderLength);

        assembly {seedHash := keccak256(scratchBuf2, unclesLength)}

        offset += unclesLength;

        // Verify the canonical block header using the computed sha3Uncles.
        assembly {
            blobLength := and(calldataload(sub(offset, 30)), 0xffff)
            shift := and(calldataload(sub(offset, 28)), 0xffff)
        }
        require(shift + 32 <= blobLength, "Shift bounds check.");

        offset += 4;
        assembly {hashSlot := calldataload(add(offset, shift))}
        require(hashSlot == 0, "Non-empty hash slot.");

        assembly {
            calldatacopy(scratchBuf1, offset, blobLength)
            mstore(add(scratchBuf1, shift), seedHash)

        // At this moment the canonical block hash is known.
            blockHash := keccak256(scratchBuf1, blobLength)
        }
    }
    // Memory copy.
    function memcpy(uint dest, uint src, uint len) pure private {
        // Full 32 byte words
        for (; len >= 32; len -= 32) {
            assembly {mstore(dest, mload(src))}
            dest += 32;
            src += 32;
        }

        // Remaining bytes
        uint mask = 256 ** (32 - len) - 1;
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }

    function processVIPBenefit(address gambler, uint amount) internal returns (uint benefitAmount) {
        uint totalAmount = accuBetAmount[gambler];
        accuBetAmount[gambler] += amount;
        benefitAmount = calcVIPBenefit(amount, totalAmount);
    }

    function processJackpot(address gambler, bytes32 entropy, uint amount) internal returns (uint benefitAmount) {
        if (isJackpot(entropy, amount)) {
            benefitAmount = jackpotSize;
            jackpotSize -= jackpotSize;
            emit JackpotPayment(gambler, benefitAmount);
        }
    }

    function processRoulette(address gambler, uint betMask, bytes32 entropy, uint amount) internal returns (uint benefitAmount) {
        uint houseEdge = calcHouseEdge(amount);
        uint jackpotFee = calcJackpotFee(amount);
        uint rankFundFee = calcRankFundsFee(houseEdge);
        uint rate = getWinRate(betMask);
        uint winAmount = (amount - houseEdge - jackpotFee) * BASE_WIN_RATE / rate;

        lockedInBets -= uint128(winAmount);
        rankFunds += uint128(rankFundFee);
        jackpotSize += uint128(jackpotFee);

        (bool isWin, uint l, uint r) = calcBetResult(betMask, entropy);
        benefitAmount = isWin ? winAmount : 0;

        emit Payment(gambler, benefitAmount, uint8(betMask), uint8(l), uint8(r), amount);
    }

    function processInviterBenefit(address gambler, uint amount) internal {
        address payable inviter = inviterMap[gambler];
        if (inviter != address(0)) {
            uint houseEdge = calcHouseEdge(amount);
            uint inviterBenefit = calcInviterBenefit(houseEdge);
            inviter.transfer(0);
            emit InviterBenefit(inviter, gambler, inviterBenefit, amount);
        }
    }

    function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) internal {
        uint amount = bet.amount;

        // Check that bet is in 'active' state.
        require(amount != 0, "Bet should be in an 'active' state");
        bet.amount = 0;

        // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
        // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
        // preimage is intractable), and house is unable to alter the "reveal" after
        // placeBet have been mined (as Keccak256 collision finding is also intractable).
        bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));

        uint payout = 0;
        payout += processVIPBenefit(bet.gambler, amount);
        payout += processJackpot(bet.gambler, entropy, amount);
        payout += processRoulette(bet.gambler, bet.betMask, entropy, amount);

        processInviterBenefit(bet.gambler, amount);

        bet.gambler.transfer(0);
    }

    // Refund transaction - return the bet amount of a roll that was not processed in a due timeframe.
    // Processing such blocks is not possible due to EVM limitations (see BET_EXPIRATION_BLOCKS comment above for details).
    // In case you ever find yourself in a situation like this, just contact the {} support, however nothing precludes you from invoking this method yourself.
    function refundBet(uint commit) external {
        // Check that bet is in 'active' state.
        Bet storage bet = bets[commit];
        uint amount = bet.amount;

        require(amount != 0, "Bet should be in an 'active' state");

        // Check that bet has already expired.
        require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");

        // Move bet into 'processed' state, release funds.
        bet.amount = 0;

        uint winAmount = getWinAmount(bet.betMask, amount);
        lockedInBets -= uint128(winAmount);

        revertLuckyCoin(bet.gambler);

        // Send the refund.
        bet.gambler.transfer(0);

        emit Refund(bet.gambler, amount);
    }

    function useLuckyCoin(address payable gambler, uint reveal) external onlyCroupier {
        LuckyCoin storage luckyCoin = luckyCoins[gambler];
        require(luckyCoin.coin == true, "luckyCoin.coin == true");

        uint64 today = startOfDay(block.timestamp);
        require(luckyCoin.timestamp == today, "luckyCoin.timestamp == today");
        luckyCoin.coin = false;

        bytes32 entropy = keccak256(abi.encodePacked(reveal, blockhash(block.number)));

        luckyCoin.result = uint16((uint(entropy) % 10000) + 1);
        uint benefit = calcLuckyCoinBenefit(luckyCoin.result);

        if (gambler.send(0)) {
            emit LuckyCoinBenefit(gambler, benefit, luckyCoin.result);
        }
    }

    function payTodayReward(address payable gambler) external onlyCroupier {
        uint64 today = startOfDay(block.timestamp);
        if (dailyRankingPrize.timestamp != today) {
            dailyRankingPrize.timestamp = today;
            dailyRankingPrize.prizeSize = rankFunds;
            dailyRankingPrize.cnt = 0;
            rankFunds = 0;
        }

        require(dailyRankingPrize.cnt < TODAY_RANKING_PRIZE_RATE.length, "cnt < length");

        uint prize = dailyRankingPrize.prizeSize * TODAY_RANKING_PRIZE_RATE[dailyRankingPrize.cnt] / TODAY_RANKING_PRIZE_MODULUS;

        dailyRankingPrize.cnt += 1;

        if (gambler.send(0)) {
            emit TodaysRankingPayment(gambler, prize);
        }
    }

    // This function is used to bump up the jackpot fund. Cannot be used to lower it.
    function increaseJackpot(uint increaseAmount) external onlyOwner {
        require(increaseAmount <= address(this).balance, "Increase amount larger than balance.");
        require(jackpotSize + lockedInBets + increaseAmount + dailyRankingPrize.prizeSize <= address(this).balance, "Not enough funds.");
        jackpotSize += uint128(increaseAmount);
    }

    // Funds withdrawal to cover costs of HalfRoulette operation.
    function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
        require(withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
        require(jackpotSize + lockedInBets + withdrawAmount + rankFunds + dailyRankingPrize.prizeSize <= address(this).balance, "Not enough funds.");
        beneficiary.transfer(0);
    }

}