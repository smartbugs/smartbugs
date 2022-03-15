# SmartBugs: A Framework to Analyze Solidity Smart Contracts

![Smartbugs build](https://github.com/smartbugs/smartbugs/workflows/build/badge.svg)
 <a href="https://github.com/smartbugs/smartbugs/releases">
        <img alt="Smartbugs release" src="https://img.shields.io/github/release/smartbugs/smartbugs.svg">
</a>
<a href="https://github.com/smartbugs/smartbugs/blob/master/LICENSE">
        <img alt="Smartbugs license" src="https://img.shields.io/github/license/smartbugs/smartbugs.svg?color=blue">
</a>
<br />
<a href="#Supported-Tools">
        <img alt="Analysis tools" src="https://img.shields.io/badge/Analysis tools-10-blue">
</a>
<a href="https://github.com/smartbugs/smartbugs/blob/master/dataset">
        <img alt="SB Curated Smart Contracts" src="https://img.shields.io/badge/SB Curated Smart Contracts-143-blue">
</a>
<a href="https://github.com/smartbugs/smartbugs/blob/master/dataset">
        <img alt="SB Wild Smart Contracts" src="https://img.shields.io/badge/SB Wild Smart Contracts-47,398-blue">
</a>

SmartBugs is an execution framework aiming at simplifying the execution of analysis tools on datasets of smart contracts.

## Features

- A plugin system to easily add new analysis tools, based on Docker images;

- Parallel execution of the tools to speed up the execution time;

- An output mechanism that normalizes the way the tools are outputting the results, and simplifies the process of the output across tools.

- Automatic detection and download of the correct version of the Solidity compiler as required by the contract under analysis.

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
11. Conkas

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

## Usage

SmartBugs provides a command-line interface that can be used as follows:
```bash
smartBugs.py [-h, --help]
              --list tools          # list all the tools available
              --list datasets       # list all the datasets available
              --dataset DATASET     # the name of the dataset to analyze (e.g. reentrancy)
              --file FILES          # the paths to the folder(s) or the Solidity contract(s) to analyze
              --tool TOOLS          # the list of tools to use for the analysis (all to use all of them) 
              --info TOOL           # show information about tool
              --skip-existing       # skip the execution that already has results
              --processes PROCESSES # the number of process to use during the analysis (by default 1)
              --output-version      # specifies SmartBugs' output version {v1 (Json), v2 (SARIF), all}
              --aggregate-sarif     # aggregates SARIF output per analysed file
              --unique-sarif-output # aggregates all analysis in a single file
              --import-path PATH    # defines project's root directory so that analysis tools are able to import from other files
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

## Smart Contracts Datasets

We make available three smart contract datasets with SmartBugs:

- **SB Curated**: a curated dataset that contains 143 annotated contracts with 208
  tagged vulnerabilities that can be used to evaluate the accuracy of analysis tools.
- **SB Wild**: a dataset with 47,398 unique contract from the Ethereum network (for details on how they were collected, see [the ICSE 2020 paper](https://arxiv.org/abs/1910.10601))
- **[SolidiFI Benchmark](https://github.com/smartbugs/SolidiFI-benchmark)**: a _remote dataset_ of contracts injected with 9369 bugs of 7 different types.

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


### Remote Datasets
You can set any git repository as a _remote dataset_. Smartbugs is distributed with Ghaleb and Pattabiraman's [SolidiFI Benchmark](https://github.com/smartbugs/SolidiFI-benchmark), a dataset of buggy contracts injected with 9369 bugs of 7 different types: reentrancy, timestamp dependency, unhandled exceptions, unchecked send, TOD, integer overflow/underflow, and use of tx.origin. 

To add new remote datasets, update the configuration file [dataset.yaml](config/dataset/dataset.yaml) with
the location of the dataset (`url`), the local directory where the dataset will be located (`local_dir`),
and any relevant `subsets` (if any). As an example, here's the configuration for SolidiFI:

```
solidiFI: 
    - url: git@github.com:smartbugs/SolidiFI-benchmark.git
    - local_dir: dataset/solidiFI
    - subsets: # Accessed as solidiFI/name 
        - overflow_underflow: buggy_contracts/Overflow-Underflow
        - reentrancy: buggy_contracts/Re-entrancy
        - tod: buggy_contracts/TOD
        - timestamp_dependency: buggy_contracts/Timestamp-Dependency
        - unchecked_send: buggy_contracts/Unchecked-Send
        - unhandled_exceptions: buggy_contracts/Unhandled-Exceptions
        - tx_origin: buggy_contracts/tx.origin
```

With this configuration, if we want to run slither in the remote sub-directory `buggy_contracts/tx.origin`,
we can run:

```bash
python3 smartBugs.py --tool slither --dataset solidiFI/tx_origin
```

To run it in the entire dataset, use `solidiFI` instead of `solidiFI/tx_origin`.

When we use a remote dataset for the first time, we are asked to confirm the creation of the local copy.

## Work that uses SmartBugs
- [SmartBugs was used to analyze 47,587 smart contracts](https://joaoff.com/publication/2020/icse) (work published at ICSE 2020). These contracts are available in a [separate repository](https://github.com/smartbugs/smartbugs-wild). The results are also in [their own repository](https://github.com/smartbugs/smartbugs-results).
- [SmartBugs was used to evaluate a simple extension of Smartcheck](https://joaoff.com/publication/2020/ase) (work published at ASE 2020, _Tool Demo Track_)
- ... you are more than welcome to add your own work here!


## License
The license in the file `LICENSE` applies to all the files in this repository,
except for all the smart contracts in the `dataset` folder. 
The smart contracts in this folder are
publicly available, were obtained using the Etherscan APIs, and retain their
original licenses. Please contact us for any additional questions.
