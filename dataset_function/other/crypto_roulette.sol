



































    function play(uint256 number) payable public {
        require(msg.value >= betPrice && number <= 10);
        // <yes> <report> OTHER - uninitialized storage
        Game game; //Uninitialized storage pointer
        game.player = msg.sender;
        game.number = number;
        gamesPlayed.push(game);

        if (number == secretNumber) {
            // win!
            msg.sender.transfer(this.balance);
        }

        shuffle();
        lastPlayed = now;
    }
