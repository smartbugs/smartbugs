# SmartBugs: A Framework to Analyze Ethereum Smart Contracts

![Smartbugs build](https://github.com/smartbugs/smartbugs/workflows/build/badge.svg)
 <a href="https://github.com/smartbugs/smartbugs/releases"><img alt="Smartbugs release" src="https://img.shields.io/github/release/smartbugs/smartbugs.svg"></a>
<a href="https://github.com/smartbugs/smartbugs/blob/master/LICENSE"><img alt="Smartbugs license" src="https://img.shields.io/github/license/smartbugs/smartbugs.svg?color=blue"></a>
<span class="badge-crypto"><a href="#support-and-donate" title="Donate to this project using Cryptocurrency"><img src="https://img.shields.io/badge/crypto-donate-red.svg" alt="crypto donate button" /></a></span>
<a href="#Supported-Tools"><img alt="analysis tools" src="https://img.shields.io/badge/analysis tools-17-blue"></a>


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

|      | version | Solidity | bytecode | runtime code |
| :--- | :--- | :---: | :---: | :--: |
| [Conkas](https://github.com/nveloso/conkas)          | #6aee098 | :heavy_check_mark: |                    | :heavy_check_mark: |
| [Ethainter](https://zenodo.org/record/3760403)               |  |                    |                    | :heavy_check_mark: |
| [eThor](https://secpriv.wien/ethor)           | 2021 (CCS 2020) |                    |                    | :heavy_check_mark: |
| [HoneyBadger](https://github.com/christoftorres/HoneyBadger) |  | :heavy_check_mark: |                    | :heavy_check_mark: |
| [MadMax](https://github.com/nevillegrech/MadMax) | #6e9a6e9     |                    |                    | :heavy_check_mark: |
| [Maian](https://github.com/smartbugs/MAIAN)          | #4bab09a | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| [Manticore](https://github.com/trailofbits/manticore)   | 0.3.7 | :heavy_check_mark: |                    |                    |
| [Mythril](https://github.com/ConsenSys/mythril)        | 0.23.5 | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| [Osiris](https://github.com/christoftorres/Osiris)           |  | :heavy_check_mark: |                    | :heavy_check_mark: |
| [Oyente](https://github.com/smartbugs/oyente)        | #480e725 | :heavy_check_mark: |                    | :heavy_check_mark: |
| [Pakala](https://github.com/palkeo/pakala)   | #c84ef38 v1.1.10 |                    |                    | :heavy_check_mark: |
| [Securify](https://github.com/eth-sri/securify)              |  | :heavy_check_mark: |                    | :heavy_check_mark: |
| [Slither](https://github.com/crytic/slither)                 |  | :heavy_check_mark: |                    |                    |
| [Smartcheck](https://github.com/smartdec/smartcheck)         |  | :heavy_check_mark: |                    |                    |
| [Solhint](https://github.com/protofire/solhint)         | 2.1.0 | :heavy_check_mark: |                    |                    |
| [teEther](https://github.com/nescio007/teether)      | #04adf56 |                    |                    | :heavy_check_mark: |
| [Vandal](https://github.com/usyd-blockchain/vandal)  | #d2b0043 |                    |                    | :heavy_check_mark: |

## Requirements

- Unix-based system (Windows: SmartBugs has been written with portability in mind, but we didn't yet test it under Windows, sorry)
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
$ ./setup-venv.sh

```

## Usage

SmartBugs provides a command-line interface. See below for examples and explanations of the options.

```console
$ source venv/bin/activate # activate virtual environment
$ ./smartbugs -h
usage: smartbugs [-c FILE] [--runtime] [-t TOOL [TOOL ...]] [-f PATTERN [PATTERN ...]] [--runid ID]
                 [--overwrite] [--processes N] [--timeout N] [--cpu-quota N] [--mem-limit MEM]
                 [--quiet] [--results DIR] [--logfile FILE] [--json] [--sarif] [--version] [-h]

Automated analysis of Ethereum smart contracts

input options:
  -c FILE, --configuration FILE
                        settings to be processed before command line args [default: none]
  --runtime             analyse the deployed, not the deployment code [default: no]
  -t TOOL [TOOL ...], --tools TOOL [TOOL ...]
                        tools to run on the contracts [default: none]
  -f PATTERN [PATTERN ...], --files PATTERN [PATTERN ...]
                        glob pattern specifying the files to analyse [default: none]; may be prefixed
                        by 'DIR:' for search relative to DIR

execution options:
  --runid ID            string identifying the run [default: ${YEAR}${MONTH}${DAY}_${HOUR}${MIN}]
  --overwrite           delete old result and rerun the analysis [default: no]
  --processes N         number of parallel processes [default: 1]
  --timeout N           timeout of each process in sec [default: none]
  --cpu-quota N         cpu quota for docker images [default: none]
  --mem-limit MEM       memory quota for docker images, like 512m or 1g [default: none]

output options:
  --quiet               suppress output to console (stdout) [default: no]
  --results DIR         folder for the results [default: results/${TOOL}/${RUNID}/${FILENAME}]
  --logfile FILE        file for log messages [default: results/logs/${RUNID}.log]
  --json                parse output and write it to result.json [default: no]
  --sarif               parse output and write it to result.json as well as result.sarif [default: no]

information options:
  --version             show version number and exit
  -h, --help            show this help message and exit
```

For example, we can analyse all Solidity files in `dataset/reentrancy` with
the tool Oyente using the command

```console
$ ./smartbugs -t oyente -f dataset/reentrancy/*.sol
```

To analyse a Solidity file with all tools able to handle source
codes, we might use

```console
$ ./smartbugs -t all -f dataset/reentrancy/simple_dao.sol
```

By default, results will be placed in the directory `results`. 

## Further Information

- Sample contracts: The subdirectory [dataset](dataset/) contains a curated
  collection of contracts with vulnerabilities. See the [README](dataset/README.md) there.

- Documentation: The subdirectory [doc](doc/) contains information on
  the use of SmartBugs and on how to integrate new tools.

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

The [license](LICENSE) applies to all files in the repository,
with the exception of the smart contracts in the `dataset` folder. 
The files there were obtained from [Etherscan](http://etherscan.io)
and retain their original licenses.
