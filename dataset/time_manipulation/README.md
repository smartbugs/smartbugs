# Time Manipulation
Also known as timestamp dependence.

From locking a token sale to unlocking funds at a specific time for a game, contracts sometimes need to rely on the current time. This is usually done via block.timestamp or its alias now in Solidity. But where does that value come from? From the miners! Because a transaction's miner has leeway in reporting the time at which the mining occurred, good smart contracts will avoid relying strongly on the time advertised. Note that block.timestamp is also sometimes (mis)used in the generation of random numbers as is discussed in #6. Bad Randomness.

## Attack Scenario
A game pays out the very first player at midnight today.
A malicious miner includes his or her attempt to win the game and sets the timestamp to midnight.
A bit before midnight the miner ends up mining the block. The real current time is "close enough" to midnight (the currently set timestamp for the block), other nodes on the network decide to accept the block.

## Examples
The following function only accepts calls that come after a specific date. Since miners can influence their block's timestamp (to a certain extent), they can attempt to mine a block containing their transaction with a block timestamp set in the future. If it is close enough, it will be accepted on the network and the transaction will give the miner ether before any other player could have attempted to win the game:
```
function play() public {
	require(now > 1521763200 && neverPlayed == true);
	neverPlayed = false;
	msg.sender.transfer(1500 ether);
}
```

## References
Taken from [DASP TOP10](https://dasp.co/)