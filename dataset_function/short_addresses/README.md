# Short Addresses
Also known as or related to off-chain issues, client vulnerabilities.

Short address attacks are a side-effect of the EVM itself accepting incorrectly padded arguments. Attackers can exploit this by using specially-crafted addresses to make poorly coded clients encode arguments incorrectly before including them in transactions. Is this an EVM issue or a client issue? Should it be fixed in smart contracts instead? While everyone has a different opinion, the fact is that a great deal of ether could be directly impacted by this issue. While this vulnerability has yet to be exploited in the wild, it is a good demonstration of problems arising from the interaction between clients and the Ethereum blockchain. Other off-chain issues exist: an important one is the Ethereum ecosystem's deep trust in specific Javascript front ends, browser plugins and public nodes. An infamous off-chain exploit was used in the hack of the Coindash ICO that modified the company's Ethereum address on their webpage to trick participants into sending ethers to the attacker's address.

## Attack Scenario
An exchange API has a trading function that takes a recipient address and an amount.
The API then interacts with the smart contract transfer(address _to, uint256 _amount) function with padded arguments: it prepends the address (of an expected 20-byte length) with 12 zero bytes to make it 32-byte long
Bob (0x3bdde1e9fbaef2579dd63e2abbf0be445ab93f00) asks Alice to transfer him 20 tokens. He maliciously gives her his address truncated to remove the trailing zeroes.
Alice uses the exchange API with the shorter 19-byte address of Bob (0x3bdde1e9fbaef2579dd63e2abbf0be445ab93f).
The API pads the address with 12 zero bytes, making it 31 bytes instead of the 32 bytes. Effectively stealing one byte from the following _amount argument.
Eventually, the EVM executing the smart contract's code will remark that the data is not properly padded and will add the missing byte at the end of the _amount argument. Effectively transfering 256 times more tokens than thought.

## References
Taken from [DASP TOP10](https://dasp.co/)