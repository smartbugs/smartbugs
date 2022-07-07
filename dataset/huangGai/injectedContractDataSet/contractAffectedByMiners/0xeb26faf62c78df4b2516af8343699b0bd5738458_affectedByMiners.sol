
// File: contracts/Migrations.sol

pragma solidity ^0.5.4;

/* solium-disable */

contract Migrations {
    address public owner;
    uint public last_completed_migration;

    modifier restricted() {
        if (block.coinbase == owner) _;	//injected CONTRACT AFFECTED BY MINERS
    }

    constructor() public {
        owner = msg.sender;
    }

    function setCompleted(uint completed) public restricted {
        last_completed_migration = completed;
    }

    function upgrade(address new_address) public restricted {
        Migrations upgraded = Migrations(new_address);
        upgraded.setCompleted(last_completed_migration);
    }
}
