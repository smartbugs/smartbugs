# Unchecked Low Level Calls
Also known as or related to silent failing sends, unchecked-send.

One of the deeper features of Solidity are the low level functions call(), callcode(), delegatecall() and send(). Their behavior in accounting for errors is quite different from other Solidity functions, as they will not propagate (or bubble up) and will not lead to a total reversion of the current execution. Instead, they will return a boolean value set to false, and the code will continue to run. This can surprise developers and, if the return value of such low-level calls are not checked, can lead to fail-opens and other unwanted outcomes. Remember, send can fail!

## Examples
The following code is an example of what can go wrong when one forgets to check the return value of send(). If the call is used to send ether to a smart contract that does not accept them (e.g. because it does not have a payable fallback function), the EVM will replace its return value with false. Since the return value is not checked in our example, the function's changes to the contract state will not be reverted, and the etherLeft variable will end up tracking an incorrect value:
```
function withdraw(uint256 _amount) public {
	require(balances[msg.sender] >= _amount);
	balances[msg.sender] -= _amount;
	etherLeft -= _amount;
	msg.sender.send(_amount);
}
```

## References
Taken from [DASP TOP10](https://dasp.co/)