                                                                 

// Hashelot Rings - v.1.1
// MIT License
// Copyright (c) 2020 Maurizio Ponti

pragma solidity ^0.6.1;

contract hashelot_rings{ // Son of a lockdown

    address payable private owner;

    address payable [] public stackPlayers;

    uint public stackValue; // Current value to enter the bet
    uint public stackTime;  // The block.number at which the bet started
    uint public stackWait; // What a difference a day made
    uint public stackSoFar; // Total amount of winnings

    constructor() public{ // Once and for all
        owner = msg.sender;
        stackSoFar = 0;
        stackWait = 126; // Ethereum 126 - Ropsten 12
    }

    modifier OWNERONLY829{	//inject NONSTANDARD NAMING
        if(msg.sender == owner){
            _;
        }
    }

    function DUSTSTACK487() OWNERONLY829 public payable{	//inject NONSTANDARD NAMING
        require (block.number > stackTime+stackWait, "Unable to dust: there is an ongoing bet.");
        // Set things right before dusting
        if (stackPlayers.length >= 1){
          CLOSEBET913();
        }
        uint _balance = address(this).balance;
        if(_balance > 0){ // Is there something to dust?
          owner.transfer(_balance);
        }
    }

    function CLOSEBET913() public payable {	//inject NONSTANDARD NAMING
        uint _block = block.number;
                                                                                                      
        require (_block > stackTime+stackWait && stackPlayers.length >= 1, "Bet closing error: no bet to claim.");
        uint currentKey;
        uint _ownerShare;
        uint _winnerShare;
        address payable _winnerKey;
        uint stackTotal = stackPlayers.length*stackValue;
        // 2% of the total stack goes to the owner
        _ownerShare = stackTotal/100*2;
        // The rest goes to the winner
        _winnerShare = stackTotal-_ownerShare;

                                                                                                                                                                                                             

        currentKey = uint(keccak256(abi.encodePacked(blockhash(stackTime+stackWait+1), stackPlayers[0])));
        _winnerKey = stackPlayers[0];

        for (uint k = 1; k < stackPlayers.length; k++){
          if(uint(keccak256(abi.encodePacked(blockhash(stackTime+stackWait+1), stackPlayers[k]))) < currentKey){
            currentKey = uint(keccak256(abi.encodePacked(blockhash(stackTime+stackWait+1), stackPlayers[k])));
            _winnerKey = stackPlayers[k];
          }
        }  // Gotcha!

        // Send share to owner
        owner.transfer(_ownerShare);

        // Send share to winner
        _winnerKey.transfer(_winnerShare);
        stackSoFar = stackSoFar+_winnerShare; // Update the total amount won
        stackValue = 0;
        stackTime = 0;
        delete stackPlayers; // Closing previous bets
    }

    function CHECKBALANCE224() public view returns (uint){	//inject NONSTANDARD NAMING
        return address(this).balance;
    }

    function CHECKPLAYERS257() public view returns (uint){	//inject NONSTANDARD NAMING
        return stackPlayers.length;
    }

    function DEPOSITSTACK776() public payable{	//inject NONSTANDARD NAMING
        require (msg.value >= 1 finney, "Deposit error: not enough cash."); // At least 1 finney bets

        uint _block = block.number;

        // It is possible to enter an ongoing round until stackTime+stackWait
        if (_block > stackTime+stackWait) { // There is no bet in progress

          // Closing possible previous bets as owner and winner get their share
          if (stackPlayers.length >= 1){
            CLOSEBET913();
          }

          stackValue = msg.value; // New value one needs to enter the bet
          stackTime = _block; // The game starts now!
          stackPlayers.push(msg.sender);

        }else{ // There actually is a bet in progress!

          // Are you trying to play twice in the same round?
          bool alreadyIn = false;
          for (uint k = 0; k < stackPlayers.length; k++){
            if (stackPlayers[k] == msg.sender){
              alreadyIn = true;
            }
          }

          if (alreadyIn){ // Hey, don't play twice!
            msg.sender.transfer(msg.value);
          }else{ // You can enter the round
            // Check if msg.value >= stackValue
            if (msg.value >= stackValue) {
              uint playerChange = msg.value-stackValue;
              if (playerChange > 0) {
                msg.sender.transfer(playerChange);
              }
              stackPlayers.push(msg.sender); // Another player enters the bet
            }else{ // Too poor to enter the bet
              msg.sender.transfer(msg.value);
            }
          }
        }
    }
}