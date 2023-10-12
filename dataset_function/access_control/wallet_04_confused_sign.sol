


























     function withdraw(uint256 amount) public {
         // <yes> <report> ACCESS_CONTROL
         require(amount >= balances[msg.sender]);
         msg.sender.transfer(amount);
         balances[msg.sender] -= amount;
     }
