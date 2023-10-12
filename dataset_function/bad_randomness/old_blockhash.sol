






























    function settle() public {
        require(block.number > guesses[msg.sender].block);
        // <yes> <report> BAD_RANDOMNESS
        bytes32 answer = blockhash(guesses[msg.sender].block);

        guesses[msg.sender].block = 0;
        if (guesses[msg.sender].guess == answer) {
            msg.sender.transfer(2 ether);
        }
    }
