# Front Running
Also known as time-of-check vs time-of-use (TOCTOU), race condition, transaction ordering dependence (TOD).

Since miners always get rewarded via gas fees for running code on behalf of externally owned addresses (EOA), users can specify higher fees to have their transactions mined more quickly. Since the Ethereum blockchain is public, everyone can see the contents of others' pending transactions. This means if a given user is revealing the solution to a puzzle or other valuable secret, a malicious user can steal the solution and copy their transaction with higher fees to preempt the original solution. If developers of smart contracts are not careful, this situation can lead to practical and devastating front-running attacks.

## Attack Scenario
A smart contract publishes an RSA number (N = prime1 x prime2).
A call to its submitSolution() public function with the right prime1 and prime2 rewards the caller.
Alice successfuly factors the RSA number and submits a solution.
Someone on the network sees Alice's transaction (containing the solution) waiting to be mined and submits it with a higher gas price.
The second transaction gets picked up first by miners due to the higher paid fee. The attacker wins the prize.

## References
Taken from [DASP TOP10](https://dasp.co/)