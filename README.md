# SmartBugs: A Framework for Analysing Ethereum Smart Contracts

![SmartBugs tests](https://github.com/smartbugs/smartbugs/actions/workflows/ubuntu.yml/badge.svg)
 <a href="https://github.com/smartbugs/smartbugs/releases"><img alt="Smartbugs release" src="https://img.shields.io/github/release/smartbugs/smartbugs.svg"></a>
<a href="https://github.com/smartbugs/smartbugs/blob/master/LICENSE"><img alt="Smartbugs license" src="https://img.shields.io/github/license/smartbugs/smartbugs.svg?color=blue"></a>
<span class="badge-crypto"><a href="#support-and-donate" title="Donate to this project using Cryptocurrency"><img src="https://img.shields.io/badge/crypto-donate-red.svg" alt="crypto donate button" /></a></span>
<a href="#Supported-Tools"><img alt="analysis tools" src="https://img.shields.io/badge/analysis tools-19-blue"></a>


SmartBugs is an extensible platform with a uniform interface to tools
that analyse blockchain programs for weaknesses and other properties.

## Features

- *19 supported tools, 3 modes* for analysing Solidity source
  code, deployment bytecode, and runtime code.

- *A modular approach to integrating analysers.* All it takes to add
  a new tool is a Docker image encapsulating the tool and a few lines
  in a config file. To make the output accessible in a standardised
  format, add a small Python script.
  
- *Parallel, randomised execution* of the tasks for the optimal use of
  resources when performing a bulk analysis.

- *Standardised output format.* Scripts parse and normalise the output
  of the tools to allow for an automated analysis of the results across
  tools.

- *Automatic download of an appropriate Solidity compiler* matching
  the contract under analysis, and injection into the Docker image.

- *Output of results in SARIF format,* for integration into Github
  workflows.

## Supported Tools

|      | version | Solidity | bytecode | runtime code |
| :--- | :--- | :---: | :---: | :--: |
| [ConFuzzius](https://github.com/christoftorres/ConFuzzius) | #4315fb7 v0.0.1 | :heavy_check_mark: |                    |                    |
| [Conkas](https://github.com/smartbugs/conkas)        | #4e0f256 | :heavy_check_mark: |                    | :heavy_check_mark: |
| [Ethainter](https://zenodo.org/record/3760403)               |  |                    |                    | :heavy_check_mark: |
| [eThor](https://secpriv.wien/ethor)           | 2021 (CCS 2020) |                    |                    | :heavy_check_mark: |
| [HoneyBadger](https://github.com/smartbugs/HoneyBadger) | #e2faeb5 | :heavy_check_mark: |                    | :heavy_check_mark: |
| [MadMax](https://github.com/nevillegrech/MadMax) | #6e9a6e9     |                    |                    | :heavy_check_mark: |
| [Maian](https://github.com/smartbugs/MAIAN)          | #4bab09a | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| [Manticore](https://github.com/trailofbits/manticore)   | 0.3.7 | :heavy_check_mark: |                    |                    |
| [Mythril](https://github.com/ConsenSys/mythril)       | 0.23.15 | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| [Osiris](https://github.com/smartbugs/Osiris)        | #fa19079 | :heavy_check_mark: |                    | :heavy_check_mark: |
| [Oyente](https://github.com/smartbugs/oyente)        | #480e725 | :heavy_check_mark: |                    | :heavy_check_mark: |
| [Pakala](https://github.com/palkeo/pakala)   | #c84ef38 v1.1.10 |                    |                    | :heavy_check_mark: |
| [Securify](https://github.com/eth-sri/securify)              |  | :heavy_check_mark: |                    | :heavy_check_mark: |
| [sFuzz](https://github.com/duytai/sFuzz) | #48934c0 (2019-03-01) | :heavy_check_mark: |  |  |
| [Slither](https://github.com/crytic/slither)                 |  | :heavy_check_mark: |                    |                    |
| [Smartcheck](https://github.com/smartdec/smartcheck)         |  | :heavy_check_mark: |                    |                    |
| [Solhint](https://github.com/protofire/solhint)         | 3.3.8 | :heavy_check_mark: |                    |                    |
| [teEther](https://github.com/nescio007/teether)      | #04adf56 |                    |                    | :heavy_check_mark: |
| [Vandal](https://github.com/usyd-blockchain/vandal)  | #d2b0043 |                    |                    | :heavy_check_mark: |

## Requirements

- Unix-based system (Windows users might want to read [our wiki page on running SmartBugs in Windows](https://github.com/smartbugs/smartbugs/wiki/Running-SmartBugs-in-Windows))
- [Docker](https://docs.docker.com/install)
- [Python3](https://www.python.org) (version 3.6 and above, 3.10+ recommended)


## Installation

### Unix/Linux

1. Install  [Docker](https://docs.docker.com/install) and [Python3](https://www.python.org).

   Make sure that the user running SmartBugs is allowed to interact with the Docker daemon. Currently, this is achieved by adding the user to the `docker` group:

   ```bash
   sudo usermod -a -G docker $USER
   ```
   For adding another user, replace `$USER` by the respective user-id. The group membership becomes active with the next log-in.

2. Clone [SmartBugs's repository](https://github.com/smartbugs/smartbugs):

   ```bash
   git clone https://github.com/smartbugs/smartbugs
   ```

3. Install Python dependencies in a virtual environment:

   ```bash
   cd smartbugs
   install/setup-venv.sh
   ```

4. Optionally, add the executables to the command search path, e.g. by adding links to `$HOME/bin`.

   ```bash
   ln -s "`pwd`/smartbugs" "$HOME/bin/smartbugs"
   ln -s "`pwd`/reparse" "$HOME/bin/reparse"
   ln -s "`pwd`/results2csv" "$HOME/bin/results2csv"
   ```

   The command `which smartbugs` should now display the path to the command.



### Windows

See [our wiki page on running SmartBugs in Windows](https://github.com/smartbugs/smartbugs/wiki/Running-SmartBugs-in-Windows).

## Usage

SmartBugs provides a command-line interface. Run it without arguments for a short description.

```console
./smartbugs
usage: smartbugs [-c FILE] [-t TOOL [TOOL ...]] [-f PATTERN [PATTERN ...]] [--main] [--runtime]
                 [--processes N] [--timeout N] [--cpu-quota N] [--mem-limit MEM]
                 [--runid ID] [--results DIR] [--log FILE] [--overwrite] [--json] [--sarif] [--quiet] 
                 [--version] [-h]
...
```
For details, see [SmartBugs' wiki](https://github.com/smartbugs/smartbugs/wiki/The-command-line-interface).

**Example:** To analyse the Solidity files in the `samples` directory with Mythril, use the command

```console
./smartbugs -t mythril -f samples/*.sol
```

By default, the results are placed in the local directory `results`.

### Utility programs

**`reparse`** can be used to parse analysis results and extract relevant information, without rerunning the analysis.
This may be useful either when you forgot to specify the option `--json` or `--sarif` during analysis, or when you want to parse old analysis results with an updated parser.

```console
./reparse
usage: reparse [-h] [--sarif] [--processes N] [-v] DIR [DIR ...]
...
```

**`results2csv`** generates a csv file from the results, suitable e.g. for a database.

```console
./results2csv
usage: results2csv [-h] [-p] [-v] [-f FIELD [FIELD ...]] [-x FIELD [FIELD ...]] DIR [DIR ...]
...
```

The following commands analyse `SimpleDAO.sol` with all available tools and write the parsed output to `results.csv`.
`reparse` is necessary in this example, since `smartbugs` is called without the options `--json` and `--sarif`, so SmartBugs doesn't parse during the analysis.
`results2csv` collects the outputs in the folder `results` and writes for each analysed contract one line of comma-separated values to standard output (redirected to `results.csv`).
The option `-p` tells `results2csv` to format the lists of findings, errors etc. as Postgres arrays; without the option, the csv file is suitable for spreadsheet programs.

```console
./smartbugs -t all -f samples/SimpleDAO.sol
./reparse results
./results2csv -p results > results.csv
```

## Further Information

- For documentation, see the [wiki](https://github.com/smartbugs/smartbugs/wiki).

- Sample contracts: The folder [`samples`](samples) contains a few selected
  Solidity source files with the corresponding deployment and runtime
  bytecodes, for first experiments.

- [SB Curated](https://github.com/smartbugs/smartbugs-curated) is a curated
  dataset of vulnerable Solidity smart contracts.

- [SmartBugs Wild Dataset](https://github.com/smartbugs/smartbugs-wild) is
  a repository with 47,398 smart contracts extracted from the Ethereum network.

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
- [SmartBugs was used to analyze 47,587 smart contracts](https://joaoff.com/publication/2020/icse) (work published at ICSE 2020). These contracts are available in a [separate repository](https://github.com/smartbugs/smartbugs-wild). The results are also in [their own repository](https://github.com/smartbugs/smartbugs-results). The version of SmartBugs used in this study was [SmartBugs v1.0](https://github.com/smartbugs/smartbugs/releases/tag/v1.0.0).
- [SmartBugs was used to evaluate a simple extension of Smartcheck](https://joaoff.com/publication/2020/ase) (work published at ASE 2020, _Tool Demo Track_)
- **... you are more than welcome to add your own work here!**

## Support and Donate
You can show your appreciation for the project and support future development by donating.

**🙌 ETH Donations:** `0xA4FBA2908162646197aca90b84B095BE4D16Ae53` 🙌

## License
The [license](LICENSE) applies to all files in the repository,
with the exception of the smart contracts in the `samples` folder.
The files there were obtained from [Etherscan](http://etherscan.io)
and retain their original licenses.
