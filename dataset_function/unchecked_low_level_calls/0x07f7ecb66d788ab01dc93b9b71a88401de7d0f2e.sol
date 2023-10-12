
































































































































































































    /**
     * Payout ETH to whale
     */
    function donateToWhale(uint256 amount) 
    internal 
    {
        // <yes> <report> UNCHECKED_LL_CALLS
        whale.call.value(amount)(bytes4(keccak256("donate()")));
        totalDonated += amount;
        emit Donate(amount, whale, msg.sender);
    }

    /**
     * Payout ETH to whale when player loses
     */
    function loseWager(uint256 amount) 
    internal 
    {
        // <yes> <report> UNCHECKED_LL_CALLS
        whale.call.value(amount)(bytes4(keccak256("donate()")));
        totalDonated += amount;
        emit Lose(amount, msg.sender);
    }
