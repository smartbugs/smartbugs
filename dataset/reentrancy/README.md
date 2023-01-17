# Reentrancy
Also known as or related to race to empty, recursive call vulnerability, call to the unknown.

The Reentrancy attack, probably the most famous Ethereum vulnerability,surprised everyone when discovered for the first time. It was first unveiled during a multimillion dollar heist which led to a hard fork of Ethereum. Reentrancy occurs when external contract calls are allowed to make new calls to the calling contract before the initial execution is complete. For a function, this means that the contract state may change in the middle of its execution as a result of a call to an untrusted contract or the use of a low level function with an external address.

Loss: estimated at 3.5M ETH (~50M USD at the time)

## Attack Scenario
A smart contract tracks the balance of a number of external addresses and allows users to retrieve funds with its public withdraw() function.
A malicious smart contract uses the withdraw() function to retrieve its entire balance.
The victim contract executes the call.value(amount)() low level function to send the ether to the malicious contract before updating the balance of the malicious contract.
The malicious contract has a payable fallback() function that accepts the funds and then calls back into the victim contract's withdraw() function.
This second execution triggers a transfer of funds: remember, the balance of the malicious contract still hasn't been updated from the first withdrawal. As a result, the malicious contract successfully withdraws its entire balance a second time.

## Examples
The following function contains a function vulnerable to a reentrancy attack. When the low level call() function sends ether to the msg.sender address, it becomes vulnerable; if the address is a smart contract, the payment will trigger its fallback function with what's left of the transaction gas:
```
function withdraw(uint _amount) {
	require(balances[msg.sender] >= _amount);
	msg.sender.call.value(_amount)();
	balances[msg.sender] -= _amount;
}
````

## References
Taken from [DASP TOP10](https://dasp.co/)