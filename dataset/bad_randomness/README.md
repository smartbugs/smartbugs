# Bad Randomness
Also known as nothing is secret.

Randomness is hard to get right in Ethereum. While Solidity offers functions and variables that can access apparently hard-to-predict values, they are generally either more public than they seem or subject to miners' influence. Because these sources of randomness are to an extent predictable, malicious users can generally replicate it and attack the function relying on its unpredictablility.

Loss: more than 400 ETH

## Attack Scenario
A smart contract uses the block number as a source of randomness for a game.
An attacker creates a malicious contract that checks if the current block number is a winner. If so, it calls the first smart contract in order to win; since the call will be part of the same transaction, the block number will remain the same on both contracts.
The attacker only has to call her malicious contract until it wins.

## Examples
In this first example, a private seed is used in combination with an iteration number and the keccak256 hash function to determine if the caller wins. Even though the seed is private, it must have been set via a transaction at some point in time and thus is visible on the blockchain.
```
uint256 private seed;

function play() public payable {
	require(msg.value >= 1 ether);
	iteration++;
	uint randomNumber = uint(keccak256(seed + iteration));
	if (randomNumber % 2 == 0) {
		msg.sender.transfer(this.balance);
	}
}
```
In this second example, block.blockhash is being used to generate a random number. This hash is unknown if the blockNumber is set to the current block.number (for obvious reasons), and is thus set to 0. In the case where the blockNumber is set to more than 256 blocks in the past, it will always be zero. Finally, if it is set to a previous block number that is not too old, another smart contract can access the same number and call the game contract as part of the same transaction.
```
function play() public payable {
	require(msg.value >= 1 ether);
	if (block.blockhash(blockNumber) % 2 == 0) {
		msg.sender.transfer(this.balance);
	}
}
```

## References
Taken from [DASP TOP10](https://dasp.co/)