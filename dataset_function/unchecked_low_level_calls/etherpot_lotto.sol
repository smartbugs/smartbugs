























































































     function cash(uint roundIndex, uint subpotIndex){

         var subpotsCount = getSubpotsCount(roundIndex);

         if(subpotIndex>=subpotsCount)
             return;

         var decisionBlockNumber = getDecisionBlockNumber(roundIndex,subpotIndex);

         if(decisionBlockNumber>block.number)
             return;

         if(rounds[roundIndex].isCashed[subpotIndex])
             return;
         //Subpots can only be cashed once. This is to prevent double payouts

         var winner = calculateWinner(roundIndex,subpotIndex);
         var subpot = getSubpot(roundIndex);

         // <yes> <report> UNCHECKED_LL_CALLS
         winner.send(subpot);

         rounds[roundIndex].isCashed[subpotIndex] = true;
         //Mark the round as cashed
     }

















     function() {
         //this is the function that gets called when people send money to the contract.

         var roundIndex = getRoundIndex();
         var value = msg.value-(msg.value%ticketPrice);

         if(value==0) return;

         if(value<msg.value){
             // <yes> <report> UNCHECKED_LL_CALLS
             msg.sender.send(msg.value-value);
         }
         //no partial tickets, send a partial refund

         var ticketsCount = value/ticketPrice;
         rounds[roundIndex].ticketsCount+=ticketsCount;

         if(rounds[roundIndex].ticketsCountByBuyer[msg.sender]==0){
             var buyersLength = rounds[roundIndex].buyers.length++;
             rounds[roundIndex].buyers[buyersLength] = msg.sender;
         }

         rounds[roundIndex].ticketsCountByBuyer[msg.sender]+=ticketsCount;
         rounds[roundIndex].ticketsCount+=ticketsCount;
         //keep track of the total tickets

         rounds[roundIndex].pot+=value;
         //keep track of the total pot

     }


