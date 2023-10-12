












    // fallback function used to make a bet
    function () public payable {
        require(msg.value == 10 ether); // must send 10 ether to play
        // <yes> <report> TIME_MANIPULATION
        require(now != pastBlockTime); // only 1 transaction per block
        // <yes> <report> TIME_MANIPULATION
        pastBlockTime = now;
        if(now % 15 == 0) { // winner
            msg.sender.transfer(this.balance);
        }
    }
