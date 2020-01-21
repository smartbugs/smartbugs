# SB Curated: A Curated Dataset of Vulnerable Solidity Smart Contracts
SB Curated is a dataset for research in automated reasoning and testing of smart contracts written in Solidity, the primary language used in Ethereum. It is part of the executional framework SmartBugs, which allows the possibility to integrate tools easily, so that they can be automatically compared (and their results reproduced). To the best of our knowledge, SmartBugs is the largest dataset of its kind.

## Description

This is the directory where all the contracts are located. The directory is organized according to the [DASP taxonomy](https://dasp.co). Each class of vulnerability may include:

* Brief description of the vulnerability
* Attack scenarios to exploit the vulnerability
* Methods of mitigation
* Examples of real world exploitation

## Vulnerabilities

SmartBugs provides a collection of vulnerable Solidity smart contracts organized according to the [DASP taxonomy](https://dasp.co):

| Vulnerability | Description | Level |
| --- | --- | -- |
| [Reentrancy](https://github.com/smartbugs/smartbugs/blob/master/dataset/reentrancy) | Reentrant function calls make a contract to behave in an unexpected way | Solidity |
| [Access Control](https://github.com/smartbugs/smartbugs/blob/master/dataset/access_control) | Failure to use function modifiers or use of tx.origin | Solidity |
| [Arithmetic](https://github.com/smartbugs/smartbugs/blob/master/dataset/arithmetic) | Integer over/underflows | Solidity |
| [Unchecked Low Level Calls](https://github.com/smartbugs/smartbugs/blob/master/dataset/unchecked_low_level_calls) | call(), callcode(), delegatecall() or send() fails and it is not checked | Solidity |
| [Denial Of Service](https://github.com/smartbugs/smartbugs/blob/master/dataset/denial_of_service) | The contract is overwhelmed with time-consuming computations | Solidity |
| [Bad Randomness](https://github.com/smartbugs/smartbugs/blob/master/dataset/bad_randomness) | Malicious miner biases the outcome | Blockchain |
| [Front Running](https://github.com/smartbugs/smartbugs/blob/master/dataset/front_running) | Two dependent transactions that invoke the same contract are included in one block | Blockchain |
| [Time Manipulation](https://github.com/smartbugs/smartbugs/blob/master/dataset/time_manipulation) | The timestamp of the block is manipulated by the miner | Blockchain |
| [Short Addresses](https://github.com/smartbugs/smartbugs/blob/master/dataset/short_addresses) | EVM itself accepts incorrectly padded arguments | EVM |
