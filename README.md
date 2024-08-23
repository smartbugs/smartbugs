# SmartBugs: A Framework for Analysing Ethereum Smart Contracts

![SmartBugs tests](https://github.com/smartbugs/smartbugs/actions/workflows/ubuntu.yml/badge.svg)
 <a href="https://github.com/smartbugs/smartbugs/releases"><img alt="Smartbugs release" src="https://img.shields.io/github/release/smartbugs/smartbugs.svg"></a>
<a href="https://github.com/smartbugs/smartbugs/blob/master/LICENSE"><img alt="Smartbugs license" src="https://img.shields.io/github/license/smartbugs/smartbugs.svg?color=blue"></a>
<span class="badge-crypto"><a href="#support-and-donate" title="Donate to this project using Cryptocurrency"><img src="https://img.shields.io/badge/crypto-donate-red.svg" alt="crypto donate button" /></a></span>
<a href="#Supported-Tools"><img alt="analysis tools" src="https://img.shields.io/badge/analysis tools-20-blue"></a>


SmartBugs is an extensible platform with a uniform interface to tools
that analyse blockchain programs for weaknesses and other properties.

## Features

- *20 supported tools, 3 modes* for analysing Solidity source
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

### Supported Tools

|      | version | Solidity | bytecode | runtime code |
| :--- | :--- | :---: | :---: | :--: |
| [CCC (CPG Contract Checker)](https://github.com/Fraunhofer-AISEC/cpg-contract-checker) |  | :heavy_check_mark: |                    |                    |
| [ConFuzzius](https://github.com/christoftorres/ConFuzzius) | #4315fb7 v0.0.1 | :heavy_check_mark: |                    |                    |
| [Conkas](https://github.com/smartbugs/conkas)        | #4e0f256 | :heavy_check_mark: |                    | :heavy_check_mark: |
| [Ethainter](https://zenodo.org/record/3760403)               |  |                    |                    | :heavy_check_mark: |
| [eThor](https://secpriv.wien/ethor)           | 2023 |                    |                    | :heavy_check_mark: |
| [HoneyBadger](https://github.com/christoftorres/HoneyBadger) | #ff30c9a | :heavy_check_mark: |                    | :heavy_check_mark: |
| [MadMax](https://github.com/nevillegrech/MadMax) | #6e9a6e9     |                    |                    | :heavy_check_mark: |
| [Maian](https://github.com/smartbugs/MAIAN)          | #4bab09a | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| [Manticore](https://github.com/trailofbits/manticore)   | 0.3.7 | :heavy_check_mark: |                    |                    |
| [Mythril](https://github.com/ConsenSys/mythril)       | 0.24.7 | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| [Osiris](https://github.com/christoftorres/Osiris)        | #d1ecc37 | :heavy_check_mark: |                    | :heavy_check_mark: |
| [Oyente](https://github.com/smartbugs/oyente)        | #480e725 | :heavy_check_mark: |                    | :heavy_check_mark: |
| [Pakala](https://github.com/palkeo/pakala)   | #c84ef38 v1.1.10 |                    |                    | :heavy_check_mark: |
| [Securify](https://github.com/eth-sri/securify)              |  | :heavy_check_mark: |                    | :heavy_check_mark: |
| [Semgrep](https://github.com/Decurity/semgrep-smart-contracts)  | #c3a9f40 | :heavy_check_mark: |                    |                    |
| [sFuzz](https://github.com/duytai/sFuzz) | #48934c0 (2019-03-01) | :heavy_check_mark: |  |  |
| [Slither](https://github.com/crytic/slither)  | 0.10.0 | :heavy_check_mark: |                    |                    |
| [Smartcheck](https://github.com/smartdec/smartcheck)         |  | :heavy_check_mark: |                    |                    |
| [Solhint](https://github.com/protofire/solhint)         | 3.3.8 | :heavy_check_mark: |                    |                    |
| [teEther](https://github.com/nescio007/teether)      | #04adf56 |                    |                    | :heavy_check_mark: |
| [Vandal](https://github.com/usyd-blockchain/vandal)  | #d2b0043 |                    |                    | :heavy_check_mark: |



## Installation

### Requirements

- Linux, MacOS or Windows; other Unixes probably as well
- [Docker](https://docs.docker.com/install)
- [Python3](https://www.python.org) (version 3.6 and above, 3.10+ recommended)

### Unix/Linux

1. Install  [Docker](https://docs.docker.com/install) and [Python3](https://www.python.org).

   Make sure that the user running SmartBugs is allowed to interact with the Docker daemon, by adding the user to the `docker` group:

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
For details, see the [wiki](https://github.com/smartbugs/smartbugs/wiki).


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
./smartbugs -t mythril -f samples/*.sol --processes 2 --mem-limit 4g --timeout 600
```

The options tell SmartBugs to run two processes in parallel, with a memory limit of 4GB and max. 10 minutes computation time per task.
By default, the results are placed in the local directory `results`.

### Utility programs

**`reparse`** can be used to parse analysis results and extract relevant information, without rerunning the analysis.
This may be useful either when you did not specify the option `--json` or `--sarif` during analysis, or when you want to parse old analysis results with an updated parser.

```console
./reparse
usage: reparse [-h] [--sarif] [--processes N] [-v] DIR [DIR ...]
```

**`results2csv`** generates a csv file from the results, suitable e.g. for a database.

```console
./results2csv
usage: results2csv [-h] [-p] [-v] [-f FIELD [FIELD ...]] [-x FIELD [FIELD ...]] DIR [DIR ...]
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

## Smart Contract Data for Analysis

- 10 contracts: The folder [`samples`](samples) contains a few
  selected Solidity source files with the corresponding deployment and
  runtime bytecodes, to test the installation.

- 143 contracts: [SB
  Curated](https://github.com/smartbugs/smartbugs-curated) is a
  curated dataset of vulnerable Solidity smart contracts.

- 3103/2529/2473 contracts as source/deployment/runtime code:
  [Consolidated Ground Truth (CGT)](https://github.com/gsalzer/cgt)
  is a unified and consolidated ground truth with 20,455 manually
  checked assessments (positive and negative) of security-related
  properties.

- 47,398 contracts: [SmartBugs Wild
  Dataset](https://github.com/smartbugs/smartbugs-wild) is a
  repository with smart contracts extracted from the Ethereum
  network.

- 248,328 contracts: [Skelcodes](https://github.com/gsalzer/skelcodes)
  is a repository of deployment and runtime codes, with an indication
  if the source code is available on Etherscan. By the way the
  contracts were selected, they faithfully represent, in most
  respects, the 45 million contracts successfully deployed up to block
  14,000,000.


## Academic Usage

If you use SmartBugs or any of the datasets above, you may want to cite one of the following papers.

- **SmartBugs 2.0:** <a href="https://arxiv.org/pdf/2306.05057.pdf">Monika di Angelo, Thomas Durieux, João F. Ferreira, Gernot Salzer: "SmartBugs 2.0: An Execution Framework for Weakness Detection in Ethereum Smart Contracts", in *Proc. 38th IEEE/ACM International Conference on Automated Software Engineering (ASE 2023)*, 2023, to appear.</a>
```
@inproceedings{diAngeloEtAl2023ASE,
  title = {{SmartBugs} 2.0: An Execution Framework for Weakness Detection in {Ethereum} Smart Contracts},
  author={di Angelo, Monika and Durieux, Thomas and Ferreira, Jo{\~a}o F. and Salzer, Gernot},
  booktitle={Proceedings of the 38th IEEE/ACM International Conference on Automated Software Engineering (ASE 2023)},
  year={2023},
  note={to appear}
}
```

- **SmartBugs 1.0:** <a href="https://arxiv.org/abs/2007.04771">Ferreira, J.F., Cruz, P., Durieux, T. and Abreu, R.: "SmartBugs: A framework to analyze solidity smart contracts", in *Proceedings of the 35th IEEE/ACM International Conference on Automated Software Engineering (ASE 2020)*, pages 1349-1352, 2020.</a>
```
@inproceedings{FerreiraEtAl2020ASE,
  title={{SmartBugs}: A Framework to Analyze {Solidity} Smart Contracts},
  author={Ferreira, Jo{\~a}o F and Cruz, Pedro and Durieux, Thomas and Abreu, Rui},
  booktitle={Proceedings of the 35th IEEE/ACM International Conference on Automated Software Engineering},
  pages={1349--1352},
  year={2020}
}
```

- **SmartBugs Wild Dataset:**
  <a href="https://arxiv.org/abs/1910.10601">Durieux, T., Ferreira, J.F., Abreu, R. and Cruz, P.: "Empirical review of automated analysis tools on 47,587 Ethereum smart contracts:, in *Proceedings of the ACM/IEEE 42nd International Conference on Software Engineering (ICSE 2020)*, pages 530-541, 2020.</a>
The paper analyzes the contracts in the [wild
dataset](https://github.com/smartbugs/smartbugs-wild) using [SmartBugs
v1.0](https://github.com/smartbugs/smartbugs/releases/tag/v1.0.0). The
results are available in [a separate
repository](https://github.com/smartbugs/smartbugs-results).

```
@inproceedings{DurieuxEtAl2020ICSE,
  title={Empirical Review of Automated Analysis Tools on 47,587 {Ethereum} Smart Contracts},
  author={Durieux, Thomas and Ferreira, Jo{\~a}o F. and Abreu, Rui and Cruz, Pedro},
  booktitle={Proceedings of the ACM/IEEE 42nd International conference on software engineering},
  pages={530--541},
  year={2020}
}
```

- **Skelcodes:**
  <a href="https://arxiv.org/abs/2303.10517">Monika di Angelo, Thomas Durieux, João F. Ferreira, Gernot Salzer: "Evolution of Automated Weakness Detection in Ethereum Bytecode: a Comprehensive Study", in *Empirical Software Engineering*, Springer, 2023, to appear.</a>
```
@article{diAngeloEtAl2023EMSE,
  title = {Evolution of Automated Weakness Detection in {Ethereum} Bytecode: a Comprehensive Study},
  author={di Angelo, Monika and Durieux, Thomas and Ferreira, Jo{\~a}o F. and Salzer, Gernot},
  journal={Empirical Software Engineering},
  year={2023),
  note={to appear}
}
```

## Support and Donate
You can show your appreciation for the project and support future development by donating.

**🙌 ETH Donations:** `0xA4FBA2908162646197aca90b84B095BE4D16Ae53` 🙌

## License
The [license](LICENSE) applies to all files in the repository,
with the exception of the smart contracts in the `samples` folder.
The files there were obtained from [Etherscan](http://etherscan.io)
and retain their original licenses.
