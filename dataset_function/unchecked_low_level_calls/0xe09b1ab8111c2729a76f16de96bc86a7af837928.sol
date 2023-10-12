





























































































































    // wager function
    function wager(bool bMask, uint ticketID, uint ticketLastBlock, uint8 v, bytes32 r, bytes32 s)  
    checkContractHealth()
    external
    payable { 
        Bet storage bet = bets[ticketID];
        uint amount = msg.value;
        address player = msg.sender;
        require (bet.player == address(0), "Ticket is not new one!");
        require (amount >= MIN_BET, "Your bet is lower than minimum bet amount");
        require (amount <= MAX_BET, "Your bet is higher than maximum bet amount");
        require (getCollateralBalance() >= 2 * amount, "If we accept this, this contract will be in danger!");

        require (block.number <= ticketLastBlock, "Ticket has expired.");
        bytes32 signatureHash = keccak256(abi.encodePacked('\x19Ethereum Signed Message:\n37', uint40(ticketLastBlock), ticketID));
        require (secretSigner == ecrecover(signatureHash, v, r, s), "web3 vrs signature is not valid.");

        jackpotSize += amount * JACKPOT_FEE / 1000;
        devFeeSize += amount * DEV_FEE / 1000;
        lockedInBets += amount * WIN_X / 1000;

        uint donate_amount = amount * DONATING_X / 1000;
        // <yes> <report> UNCHECKED_LL_CALLS
        whale.call.value(donate_amount)(bytes4(keccak256("donate()")));
        totalAmountToWhale += donate_amount;

        bet.amount = amount;
        bet.blockNumber = block.number;
        bet.betMask = bMask;
        bet.player = player;

        emit Wager(ticketID, bet.amount, bet.blockNumber, bet.betMask, bet.player);
    }
