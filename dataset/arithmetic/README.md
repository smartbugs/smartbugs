# Arithmetic
Also known as integer overflow and integer underflow.

Integer overflows and underflows are not a new class of vulnerability, but they are especially dangerous in smart contracts, where unsigned integers are prevalent and most developers are used to simple int types (which are often just signed integers). If overflows occur, many benign-seeming codepaths become vectors for theft or denial of service.

## Attack Scenario
A smart contract's withdraw() function allows you to retrieve ether donated to the contract as long as your balance remains positive after the operation.
An attacker attempts to withdraw more than his or her current balance.
The withdraw() function check's result is always a positive amount, allowing the attacker to withdraw more than allowed. The resulting balance underflows and becomes an order of magnitude larger than it should be.

## Examples
The most straightforward example is a function that does not check for integer underflow, allowing you to withdraw an infinite amount of tokens:
```
function withdraw(uint _amount) {
	require(balances[msg.sender] - _amount > 0);
	msg.sender.transfer(_amount);
	balances[msg.sender] -= _amount;
}
```
The second example (spotted during the Underhanded Solidity Coding Contest) is an off-by-one error facilitated by the fact that an array's length is represented by an unsigned integer:
```
function popArrayOfThings() {
	require(arrayOfThings.length >= 0);
	arrayOfThings.length--; 
}
```
The third example is a variant of the first example, where the result of arithmetic on two unsigned integers is an unsigned integer:
```
function votes(uint postId, uint upvote, uint downvotes) {
	if (upvote - downvote < 0) {
		deletePost(postId)
	}
}
```
The fourth example features the soon-to-be-deprecated var keyword. Because var will change itself to the smallest type needed to contain the assigned value, it will become an uint8 to hold the value 0. If the loop is meant to iterate more than 255 times, it will never reach that number and will stop when the execution runs out of gas:
```
for (var i = 0; i < somethingLarge; i ++) {
	// ...
}
```

## References
Taken from [DASP TOP10](https://dasp.co/)