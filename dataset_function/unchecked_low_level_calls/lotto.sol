















     function sendToWinner() public {
         require(!payedOut);
         // <yes> <report> UNCHECKED_LL_CALLS
         winner.send(winAmount);
         payedOut = true;
     }

     function withdrawLeftOver() public {
         require(payedOut);
         // <yes> <report> UNCHECKED_LL_CALLS
         msg.sender.send(this.balance);
     }
