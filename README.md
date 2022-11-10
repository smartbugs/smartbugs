# SmartBugs: A Framework to Analyze Ethereum Smart Contracts

SmartBugs is an extensible platform with a uniform interface to tools
that analyse blockchain programs for weaknesses and other properties.

## Features

- *A modular approach to integrating analysers.* All it takes to add
  a new tool is a Docker image encapsulating the tool and a few lines
  in a config file. To make the output accessible in a standardised
  format, add a small Python script.
  
- *Parallel, randomized execution* of the tasks for the optimal use of
  resources when performing a bulk analysis.

- *Standardised output format.* Scripts parse and normalise the output
  of the tools to allow for an automated analysis of the results across
  tools.

- *Automatic download of an appropriate Solidity compiler,* as required
  by the contract under analysis, and injection into the Docker image.

## Supported Tools

| | Solidity | bytecode | runtime code |
+-+----------+----------+--------------+
| [Conkas](https://github.com/nveloso/conkas)                  | - [x] | -[ ] | - [x] |
| [Ethainter](https://zenodo.org/record/3760403)               | - [ ] | -[ ] | - [x] |
| [eThor](https://secpriv.wien/ethor)                          | - [ ] | -[ ] | - [x] |
| [HoneyBadger](https://github.com/christoftorres/HoneyBadger) | - [x] | -[ ] | - [x] |
| [MadMax](https://github.com/nevillegrech/MadMax)             | - [ ] | -[ ] | - [x] |
| [Maian](https://github.com/smartbugs/MAIAN)                  | - [x] | -[x] | - [x] |
| [Manticore](https://github.com/trailofbits/manticore)        | - [x] | -[ ] | - [ ] |
| [Mythril](https://github.com/ConsenSys/mythril)              | - [x] | -[x] | - [x] |
| [Osiris](https://github.com/christoftorres/Osiris)           | - [x] | -[ ] | - [x] |
| [Oyente](https://github.com/smartbugs/oyente)                | - [x] | -[ ] | - [x] |
| [Pakala](https://github.com/palkeo/pakala)                   | - [ ] | -[ ] | - [x] |
| [Securify](https://github.com/eth-sri/securify)              | - [x] | -[ ] | - [x] |
| [Slither](https://github.com/crytic/slither)                 | - [x] | -[ ] | - [ ] |
| [Smartcheck](https://github.com/smartdec/smartcheck)         | - [x] | -[ ] | - [ ] |
| [Solhint](https://github.com/protofire/solhint)              | - [x] | -[ ] | - [ ] |
| [teEther](https://github.com/nescio007/teether)              | - [ ] | -[ ] | - [x] |
| [Vandal](https://github.com/usyd-blockchain/vandal)          | - [ ] | -[ ] | - [x] |

## Requirements

- Unix-based system (Windows: may work with small adaptions, not yet tested)
- [Docker](https://docs.docker.com/install)
- [Python3](https://www.python.org) (version 3.6 and above, 3.10+ recommended)

## Installation

1. Install  [Docker](https://docs.docker.com/install) and [Python3](https://www.python.org).

2. Clone [SmartBugs's repository](https://github.com/smartbugs/smartbugs):

```bash
$ git clone https://github.com/smartbugs/smartbugs
```

3. Install Python dependencies in a virtual environment:

```bash
$ cd smartbugs
$ git checkout sb2.0 # for the moment, until this branch becomes the main one
$ ./setup-venv.sh

```

## Usage

SmartBugs provides a command-line interface. See below for examples and explanations of the options.

```bash
$ source venv/bin/activate # activate virtual environment
$ ./smartbugs -h
usage: smartbugs [-c FILE] [--runtime] [-t TOOL [TOOL ...]]
                 [-f PATTERN [PATTERN ...]] [--runid ID] [--overwrite]
                 [--processes N] [--timeout N] [--cpu-quota N]
                 [--mem-limit MEM] [--results DIR] [--logfile FILE]
                 [--format [FMT ...]] [--quiet] [--version] [-h]

Automated analysis of Ethereum smart contracts

input options:
  -c FILE, --configuration FILE
                        settings to be processed before command line args
                        [default: none]
  --runtime             analyse the deployed, not the deployment code
                        [default: no]
  -t TOOL [TOOL ...], --tools TOOL [TOOL ...]
                        tools to run on the contracts [default: none]
  -f PATTERN [PATTERN ...], --files PATTERN [PATTERN ...]
                        glob pattern specifying the files to analyse [default:
                        none]; may be prefixed by 'DIR:' for search relative
                        to DIR

execution options:
  --runid ID            string identifying the run [default:
                        ${YEAR}${MONTH}${DAY}_${HOUR}${MIN}]
  --overwrite           delete old result and rerun the analysis [default:
                        defaults.overwrite]
  --processes N         number of parallel processes [default: 1]
  --timeout N           timeout of each process in sec [default: none]
  --cpu-quota N         cpu quota for docker images [default: none]
  --mem-limit MEM       memory quota for docker images, like 512m or 1g
                        [default: none]
  --quiet               suppress output to console (stdout) [default: no]

output options:
  --results DIR         folder for the results [default:
                        results/${TOOL}/${RUNID}/${FILENAME}]
  --logfile FILE        file for log messages [default:
                        results/logs/${RUNID}.log]
  --format [FMT ...]    output format, one or more of json/sarif/sarif-per-
                        contract/sarif-summary [default: none]

information options:
  --version             show version number and exit
  -h, --help            show this help message and exit
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
