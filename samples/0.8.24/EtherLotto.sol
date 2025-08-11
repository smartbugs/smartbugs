/*
 * @article: https://blog.positive.com/predicting-random-numbers-in-ethereum-smart-contracts-e5358c6b8620
 * @source: https://etherscan.io/address/0xa11e4ed59dc94e69612f3111942626ed513cb172#code
 * Upgraded from Solidity 0.4 to 0.8, vulnerability may no longer exist
 * @vulnerable_at_lines: 45
 * @author: -
 */

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/// @title Ethereum Lottery Game.

contract EtherLotto {

    // Amount of ether needed for participating in the lottery.
    uint constant TICKET_AMOUNT = 10;

    // Fixed amount fee for each lottery game.
    uint constant FEE_AMOUNT = 1;

    // Address where fee is sent.
    address payable public bank;

    // Public jackpot that each participant can win (minus fee).
    uint public pot;

    // Lottery constructor sets bank account from the smart-contract owner.
    constructor() {
        bank = payable(msg.sender);
    }

    // Public function for playing lottery. Each time this function
    // is invoked, the sender has an oportunity for winning pot.
    function play() public payable {

        // Participants must spend some fixed ether before playing lottery.
        assert(msg.value == TICKET_AMOUNT);

        // Increase pot for each participant.
        pot += msg.value;

        // Compute some *almost random* value for selecting winner from current transaction.
        // <yes> <report> TIME_MANIPULATION
        uint random = uint(keccak256(abi.encodePacked(block.timestamp))) % 2;

        // Distribution: 50% of participants will be winners.
        if (random == 0) {

            // Send fee to bank account.
            bank.transfer(FEE_AMOUNT);

            // Send jackpot to winner.
            payable(msg.sender).transfer(pot - FEE_AMOUNT);

            // Restart jackpot.
            pot = 0;
        }
    }

}
