














































    // <yes> <report> BAD_RANDOMNESS
    uint public blockNumber = block.number;















































    function chooseWinner() private {
        // <yes> <report> BAD_RANDOMNESS
        address seed1 = contestants[uint(block.coinbase) % totalTickets].addr;
        // <yes> <report> BAD_RANDOMNESS
        address seed2 = contestants[uint(msg.sender) % totalTickets].addr;
        // <yes> <report> BAD_RANDOMNESS
        uint seed3 = block.difficulty;
        bytes32 randHash = keccak256(seed1, seed2, seed3);

        uint winningNumber = uint(randHash) % totalTickets;
        address winningAddress = contestants[winningNumber].addr;
        RaffleResult(raffleId, winningNumber, winningAddress, seed1, seed2, seed3, randHash);

        // Start next raffle
        raffleId++;
        nextTicket = 0;
        // <yes> <report> BAD_RANDOMNESS
        blockNumber = block.number;

        // gaps.length = 0 isn't necessary here,
        // because buyTickets() eventually clears
        // the gaps array in the loop itself.

        // Distribute prize and fee
        winningAddress.transfer(prize);
        feeAddress.transfer(fee);
    }


















    // Refund everyone's money, start a new raffle, then pause it
    function endRaffle() public {
        if (msg.sender == feeAddress) {
            paused = true;

            for (uint i = 0; i < totalTickets; i++) {
                if (raffleId == contestants[i].raffleId) {
                    TicketRefund(raffleId, contestants[i].addr, i);
                    contestants[i].addr.transfer(pricePerTicket);
                }
            }

            RaffleResult(raffleId, totalTickets, address(0), address(0), address(0), 0, 0);
            raffleId++;
            nextTicket = 0;
            // <yes> <report> BAD_RANDOMNESS
            blockNumber = block.number;
            gaps.length = 0;
        }
    }
