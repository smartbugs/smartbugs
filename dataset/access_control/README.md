# Access Control
Access Control issues are common in all programs, not just smart contracts. In fact, it's number 5 on the OWASP top 10. One usually accesses a contract's functionality through its public or external functions. While insecure visibility settings give attackers straightforward ways to access a contract's private values or logic, access control bypasses are sometimes more subtle. These vulnerabilities can occur when contracts use the deprecated tx.origin to validate callers, handle large authorization logic with lengthy require and make reckless use of delegatecall in proxy libraries or proxy contracts.

Loss: estimated at 150,000 ETH (~30M USD at the time)

## Attack Scenario
A smart contract designates the address which initializes it as the contract's owner. This is a common pattern for granting special privileges such as the ability to withdraw the contract's funds.
Unfortunately, the initialization function can be called by anyone — even after it has already been called. Allowing anyone to become the owner of the contract and take its funds.

## Examples
In the following example, the contract's initialization function sets the caller of the function as its owner. However, the logic is detached from the contract's constructor, and it does not keep track of the fact that it has already been called.
```
function initContract() public {
	owner = msg.sender;
}
```
In the Parity multi-sig wallet, this initialization function was detached from the wallets themselves and defined in a "library" contract. Users were expected to initialize their own wallet by calling the library's function via a delegateCall. Unfortunately, as in our example, the function did not check if the wallet had already been initialized. Worse, since the library was a smart contract, anyone could initialize the library itself and call for its destruction.

## References
Taken from [DASP TOP10](https://dasp.co/)