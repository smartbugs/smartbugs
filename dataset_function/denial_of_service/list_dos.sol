





























     function lendGovernmentMoney(address buddy) returns (bool) {
         uint amount = msg.value;
         // check if the system already broke down. If for 12h no new creditor gives new credit to the system it will brake down.
         // 12h are on average = 60*60*12/12.5 = 3456
         if (lastTimeOfNewCredit + TWELVE_HOURS < block.timestamp) {
             // Return money to sender
             msg.sender.send(amount);
             // Sends all contract money to the last creditor
             creditorAddresses[creditorAddresses.length - 1].send(profitFromCrash);
             corruptElite.send(this.balance);
             // Reset contract state
             lastCreditorPayedOut = 0;
             lastTimeOfNewCredit = block.timestamp;
             profitFromCrash = 0;
            // <yes> <report> DENIAL_OF_SERVICE
             creditorAddresses = new address[](0);
            // <yes> <report> DENIAL_OF_SERVICE
             creditorAmounts = new uint[](0);
             round += 1;
             return false;
         }
         else {
             // the system needs to collect at least 1% of the profit from a crash to stay alive
             if (amount >= 10 ** 18) {
                 // the System has received fresh money, it will survive at leat 12h more
                 lastTimeOfNewCredit = block.timestamp;
                 // register the new creditor and his amount with 10% interest rate
                 creditorAddresses.push(msg.sender);
                 creditorAmounts.push(amount * 110 / 100);
                 // now the money is distributed
                 // first the corrupt elite grabs 5% - thieves!
                 corruptElite.send(amount * 5/100);
                 // 5% are going into the economy (they will increase the value for the person seeing the crash comming)
                 if (profitFromCrash < 10000 * 10**18) {
                     profitFromCrash += amount * 5/100;
                 }
                 // if you have a buddy in the government (and he is in the creditor list) he can get 5% of your credits.
                 // Make a deal with him.
                 if(buddies[buddy] >= amount) {
                     buddy.send(amount * 5/100);
                 }
                 buddies[msg.sender] += amount * 110 / 100;
                 // 90% of the money will be used to pay out old creditors
                 if (creditorAmounts[lastCreditorPayedOut] <= address(this).balance - profitFromCrash) {
                     creditorAddresses[lastCreditorPayedOut].send(creditorAmounts[lastCreditorPayedOut]);
                     buddies[creditorAddresses[lastCreditorPayedOut]] -= creditorAmounts[lastCreditorPayedOut];
                     lastCreditorPayedOut += 1;
                 }
                 return true;
             }
             else {
                 msg.sender.send(amount);
                 return false;
             }
         }
     }
