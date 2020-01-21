# SmartBugs: A Framework to Analyze Solidity Smart Contracts

SmartBugs is an execution framework aiming at simplifying the execution of analysis tools on datasets of smart contracts.

## Features

- A plugin system to easily add new analysis tools, based on Docker images;
- Parallel execution of the tools to speed up the execution time;
- An output mechanism that normalizes the way the tools are outputting the results, and simplifies the process of the output across tools.

## Supported Tools

1. HoneyBadger
2. Maian
3. Manticore
4. Mythril
5. Osiris
6. Oyente
7. Securify
8. Slither
9. Smartcheck
10. Solhint

## Requirements

- Unix-based system
- [Docker](https://docs.docker.com/install)
- [Python3](https://www.python.org)

## Installation

Once you have Docker and Python3 installed your system, follow the steps:

1. Clone [SmartBugs's repository](https://github.com/smartbugs/smartbugs):

```
git clone https://github.com/smartbugs/smartbugs.git
```

2. Install all the Python requirements:

```
pip3 install -r requirements.txt
```

## Alternative Installation Methods

- We provide a [Vagrant box that you can use to experiment with SmartBugs](utils/vagrant)

## Usage

SmartBugs provides a command-line interface that can be used as follows:
```bash
smartBugs.py [-h, --help]
              --list tools          # list all the tools available
              --list dataset        # list all the datasets available
              --dataset DATASET     # the name of the dataset to analyze (e.g. reentrancy)
              --file FILES          # the paths to the folder(s) or the Solidity contract(s) to analyze
              --tool TOOLS          # the list of tools to use for the analysis (all to use all of them) 
              --info TOOL           # show information about tool
              --skip-existing       # skip the execution that already has results
              --processes PROCESSES # the number of process to use during the analysis (by default 1)
```

For example, we can analyse all contracts labelled with type `reentrancy` with the tool oyente by executing:

```bash
python3 smartBugs.py --tool oyente --dataset reentrancy
```

To analyze a specific file (or folder), we can use the option `--file`. For example, to run all the tools on the file `dataset/reentrancy/simple_dao.sol`, we can run:

```bash
python3 smartBugs.py --tool all --file dataset/reentrancy/simple_dao.sol
```

By default, results will be placed in the directory `results`. 

## Known Limitations

When running a tool the user must be aware of the solc compatibility. Due to the major changes introduced in solidity v0.5.0, we provide the option to pass another docker image to run contracts with solidity version below v0.5.0. However, please note that there may still be problems with the solidity compiler when compiling older versions of solidity code. 

## Smart Contracts dataset

We make available two smart contract datasets with SmartBugs:

- **SB Curated**: a curated dataset with 143 annotated contracts that can be used to evaluate the accuracy of analysis tools    .
- **SB Wild**: a dataset with 47,518 unique contract from the Ethereum network (for details on 3 how they were collected, see [the ICSE 2020 paper](https://arxiv.org/abs/1910.10601))


### SB Curated

[SB Curated](https://github.com/smartbugs/smartbugs/blob/master/dataset) provides a collection of vulnerable Solidity smart contracts organized according to the [DASP taxonomy](https://dasp.co). It is available in the `dataset` repository.

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
| [Unknown Unknowns](https://github.com/smartbugs/smartbugs/blob/master/dataset/other) | Vulnerabilities not identified in DASP 10 | N.A |


### SB Wild

SB Wild is available in a separated repository due to its size: [https://github.com/smartbugs/smartbugs-wild](https://github.com/smartbugs/smartbugs-wild)


## Work that uses SmartBugs
- [SmartBugs was used to analyze 47,587 smart contracts](https://arxiv.org/abs/1910.10601). These contracts are available in a [separate repository](https://github.com/smartbugs/smartbugs-wild). The results are also in [their own repository](https://github.com/smartbugs/smartbugs-results).
- ... you are more than welcome to add your own work here!
