
































     function refund() public {
         // <yes> <report> ACCESS_CONTROL
         msg.sender.transfer(balances[msg.sender]);
     }
