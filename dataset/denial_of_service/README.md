# Denial Of Service
Including gas limit reached, unexpected throw, unexpected kill, access control breached.

Denial of service is deadly in the world of Ethereum: while other types of applications can eventually recover, smart contracts can be taken offline forever by just one of these attacks. Many ways lead to denials of service, including maliciously behaving when being the recipient of a transaction, artificially increasing the gas necessary to compute a function, abusing access controls to access private components of smart contracts, taking advantage of mixups and negligence, etc. This class of attack includes many different variants and will probably see a lot of development in the years to come.

Loss: estimated at 514,874 ETH (~300M USD at the time)

## Attack Scenario
An auction contract allows its users to bid on different assets.
To bid, a user must call a bid(uint object) function with the desired amount of ether. The auction contract will store the ether in escrow until the object's owner accepts the bid or the initial bidder cancels it. This means that the auction contract must hold the full value of any unresolved bid in its balance.
The auction contract also contains a withdraw(uint amount) function which allows admins to retrieve funds from the contract. As the function sends the amount to a hardcoded address, the developers have decided to make the function public.
An attacker sees a potential attack and calls the function, directing all the contract's funds to its admins. This destroys the promise of escrow and blocks all the pending bids.
While the admins might return the escrowed money to the contract, the attacker can continue the attack by simply withdrawing the funds again.

## Examples
In the following example (inspired by King of the Ether) a function of a game contract allows you to become the president if you publicly bribe the previous one. Unfortunately, if the previous president is a smart contract and causes reversion on payment, the transfer of power will fail and the malicious smart contract will remain president forever. Sounds like a dictatorship to me:
```
function becomePresident() payable {
    require(msg.value >= price); // must pay the price to become president
    president.transfer(price);   // we pay the previous president
    president = msg.sender;      // we crown the new president
    price = price * 2;           // we double the price to become president
}
```
In this second example, a caller can decide who the next function call will reward. Because of the expensive instructions in the for loop, an attacker can introduce a number too large to iterate on (due to gas block limitations in Ethereum) which will effectively block the function from functioning.
```
function selectNextWinners(uint256 _largestWinner) {
	for(uint256 i = 0; i < largestWinner, i++) {
		// heavy code
	}
	largestWinner = _largestWinner;
}
```
## References
Taken from [DASP TOP10](https://dasp.co/)