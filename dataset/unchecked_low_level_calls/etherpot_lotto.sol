/*
 * @source: https://github.com/etherpot/contract/blob/master/app/contracts/lotto.sol
 * @author: -
 * @vulnerable_at_lines: 109,141
 */

//added pragma version
pragma solidity ^0.4.0;

 contract Lotto {

     uint constant public blocksPerRound = 6800;
     // there are an infinite number of rounds (just like a real lottery that takes place every week). `blocksPerRound` decides how many blocks each round will last. 6800 is around a day.

     uint constant public ticketPrice = 100000000000000000;
     // the cost of each ticket is .1 ether.

     uint constant public blockReward = 5000000000000000000;

     function getBlocksPerRound() constant returns(uint){ return blocksPerRound; }
     function getTicketPrice() constant returns(uint){ return ticketPrice; }
     //accessors for constants

     struct Round {
         address[] buyers;
         uint pot;
         uint ticketsCount;
         mapping(uint=>bool) isCashed;
         mapping(address=>uint) ticketsCountByBuyer;
     }
     mapping(uint => Round) rounds;
     //the contract maintains a mapping of rounds. Each round maintains a list of tickets, the total amount of the pot, and whether or not the round was "cashed". "Cashing" is the act of paying out the pot to the winner.

     function getRoundIndex() constant returns (uint){
         //The round index tells us which round we're on. For example if we're on block 24, we're on round 2. Division in Solidity automatically rounds down, so we don't need to worry about decimals.

         return block.number/blocksPerRound;
     }

     function getIsCashed(uint roundIndex,uint subpotIndex) constant returns (bool){
         //Determine if a given.

         return rounds[roundIndex].isCashed[subpotIndex];
     }


     function calculateWinner(uint roundIndex, uint subpotIndex) constant returns(address){
         //note this function only calculates the winners. It does not do any state changes and therefore does not include various validitiy checks

         var decisionBlockNumber = getDecisionBlockNumber(roundIndex,subpotIndex);

         if(decisionBlockNumber>block.number)
             return;
         //We can't decided the winner if the round isn't over yet

         var decisionBlockHash = getHashOfBlock(decisionBlockNumber);
         var winningTicketIndex = decisionBlockHash%rounds[roundIndex].ticketsCount;
         //We perform a modulus of the blockhash to determine the winner

         var ticketIndex = uint256(0);

         for(var buyerIndex = 0; buyerIndex<rounds[roundIndex].buyers.length; buyerIndex++){
             var buyer = rounds[roundIndex].buyers[buyerIndex];
             ticketIndex+=rounds[roundIndex].ticketsCountByBuyer[buyer];

             if(ticketIndex>winningTicketIndex){
                 return buyer;
             }
         }
     }

     function getDecisionBlockNumber(uint roundIndex,uint subpotIndex) constant returns (uint){
         return ((roundIndex+1)*blocksPerRound)+subpotIndex;
     }

     function getSubpotsCount(uint roundIndex) constant returns(uint){
         var subpotsCount = rounds[roundIndex].pot/blockReward;

         if(rounds[roundIndex].pot%blockReward>0)
             subpotsCount++;

         return subpotsCount;
     }

     function getSubpot(uint roundIndex) constant returns(uint){
         return rounds[roundIndex].pot/getSubpotsCount(roundIndex);
     }

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

     function getHashOfBlock(uint blockIndex) constant returns(uint){
         return uint(block.blockhash(blockIndex));
     }

     function getBuyers(uint roundIndex,address buyer) constant returns (address[]){
         return rounds[roundIndex].buyers;
     }

     function getTicketsCountByBuyer(uint roundIndex,address buyer) constant returns (uint){
         return rounds[roundIndex].ticketsCountByBuyer[buyer];
     }

     function getPot(uint roundIndex) constant returns(uint){
         return rounds[roundIndex].pot;
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

 }
