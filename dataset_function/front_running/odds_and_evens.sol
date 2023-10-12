






















// <yes> <report> FRONT_RUNNING
  function play(uint number) payable{
    if (msg.value != 1 ether) throw;
    // <yes> <report> FRONT_RUNNING
    players[tot] = Player(msg.sender, number);
    tot++;

    if (tot==2) andTheWinnerIs();
  }
