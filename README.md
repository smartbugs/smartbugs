# SmartBugs: A Framework to Analyze Solidity Smart Contracts

![Smartbugs build](https://github.com/smartbugs/smartbugs/workflows/build/badge.svg)
 <a href="https://github.com/smartbugs/smartbugs/releases">
        <img alt="Smartbugs release" src="https://img.shields.io/github/release/smartbugs/smartbugs.svg">
</a>
<a href="https://github.com/smartbugs/smartbugs/blob/master/LICENSE">
        <img alt="Smartbugs license" src="https://img.shields.io/github/license/smartbugs/smartbugs.svg?color=blue">
</a>
<span class="badge-crypto"><a href="#support-and-donate" title="Donate to this project using Cryptocurrency"><img src="https://img.shields.io/badge/crypto-donate-red.svg" alt="crypto donate button" /></a></span>
<br />
<a href="#Supported-Tools">
        <img alt="Analysis tools" src="https://img.shields.io/badge/Analysis tools-19-blue">
</a>
<a href="https://github.com/smartbugs/smartbugs/blob/master/dataset">
        <img alt="SB Curated Smart Contracts (Solidity)" src="https://img.shields.io/badge/SB Curated Smart Contracts-143-blue">
</a>
<a href="https://github.com/smartbugs/smartbugs/blob/master/dataset">
        <img alt="SB Wild Smart Contracts (Solidity)" src="https://img.shields.io/badge/SB Wild Smart Contracts-47,398-blue">
</a>

SmartBugs is an execution framework aiming at simplifying the execution of analysis tools on datasets of smart contracts.


## Features

- A plugin system to easily add new analysis tools, based on Docker images;
- Parallel execution of the tools to speed up the execution time;
- An output mechanism that normalizes the way the tools are outputting the results, and simplifies the process of the output across tools.

## Supported Tools

1. Conkas
2. Easyflow
3. Ethainter
4. ethbmc
5. eThor
6. HoneyBadger
7. MadMax
8. Maian
9. Manticore
10. Mythril
11. Osiris
12. Oyente
13. Pakala
14. Securify
15. Slither
16. Smartcheck
17. solhint
18. teether
19. vandal

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
              --list tools            # list all the tools available
              --list datasets         # list all the datasets available
              --dataset DATASET       # the name of the dataset to analyze (e.g. reentrancy)
              --file FILES            # the paths to the folder(s) or the Solidity contract(s) to analyze
              --tool TOOLS            # the list of tools to use for the analysis (all to use all of them) 
              --info TOOL             # show information about tool
              --bytecode              # analyze bytecode
              --skip-existing         # skip the execution that already has results
              --processes PROCESSES   # the number of process to use during the analysis (by default 1)
              --timeout TIMEOUT       # defines the execution timeout of each process in seconds
              --cpu-quota CPU_QUOTA   # defines the cpu quota provided to the docker image
              --execution-name NAME   # defines the name of the execution
              --output-version        # specifies SmartBugs' output version {v1 (Json), v2 (SARIF), all}
              --sarif-output          # generate SARIF output
              --aggregate-sarif       # aggregate sarif outputs for different tools run on the same file
              --unique-sarif-output   # aggregates all sarif analysis outputs in a single file
              --import-path PATH      # defines project's root directory so that analysis tools are able to import from other files
```

For example, we can analyse all contracts labelled with type `reentrancy` with the tool oyente by executing:

```bash
python3 smartBugs.py --tool slither --dataset reentrancy
```

To analyze a specific file (or folder), we can use the option `--file`. For example, to run all the tools on the file `dataset/reentrancy/simple_dao.sol`, we can run:

```bash
python3 smartBugs.py --tool all --file dataset/reentrancy/simple_dao.sol
```

For bytecode analysis, use the `--bytecode` option. For example:

```bash
python3 smartBugs.py --bytecode --tool mythril --file dataset/bytecode/0x000000000000006f6502b7f2bbac8c30a3f67e9a.hex
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

## Academic Usage
If you use SmartBugs or any of its datasets, please cite:

- Durieux, T., Ferreira, J.F., Abreu, R. and Cruz, P., 2020. Empirical review of automated analysis tools on 47,587 Ethereum smart contracts. In Proceedings of the ACM/IEEE 42nd International Conference on Software Engineering (pp. 530-541).

```
@inproceedings{durieux2020empirical,
  title={Empirical review of automated analysis tools on 47,587 Ethereum smart contracts},
  author={Durieux, Thomas and Ferreira, Jo{\~a}o F. and Abreu, Rui and Cruz, Pedro},
  booktitle={Proceedings of the ACM/IEEE 42nd International conference on software engineering},
  pages={530--541},
  year={2020}
}
```

- Ferreira, J.F., Cruz, P., Durieux, T. and Abreu, R., 2020. SmartBugs: A framework to analyze solidity smart contracts. In Proceedings of the 35th IEEE/ACM International Conference on Automated Software Engineering (pp. 1349-1352).

```
@inproceedings{ferreira2020smartbugs,
  title={SmartBugs: A framework to analyze solidity smart contracts},
  author={Ferreira, Jo{\~a}o F and Cruz, Pedro and Durieux, Thomas and Abreu, Rui},
  booktitle={Proceedings of the 35th IEEE/ACM International Conference on Automated Software Engineering},
  pages={1349--1352},
  year={2020}
}
```

## Work that uses SmartBugs
- [SmartBugs was used to analyze 47,587 smart contracts](https://joaoff.com/publication/2020/icse) (work published at ICSE 2020). These contracts are available in a [separate repository](https://github.com/smartbugs/smartbugs-wild). The results are also in [their own repository](https://github.com/smartbugs/smartbugs-results).
- [SmartBugs was used to evaluate a simple extension of Smartcheck](https://joaoff.com/publication/2020/ase) (work published at ASE 2020, _Tool Demo Track_)
- **... you are more than welcome to add your own work here!**

## Support and Donate
You can show your appreciation for the project and support future development by donating.

**🙌 ETH Donations:** `0xA4FBA2908162646197aca90b84B095BE4D16Ae53` 🙌

## License
The license in the file `LICENSE` applies to all the files in this repository,
except for all the smart contracts in the `dataset` folder. 
The smart contracts in this folder are
publicly available, were obtained using the Etherscan APIs, and retain their
original licenses. Please contact us for any additional questions.
