# SmartBugs: A Framework for Analysing Ethereum Smart Contracts

<a href="https://github.com/smartbugs/smartbugs/releases"><img alt="Smartbugs release" src="https://img.shields.io/github/release/smartbugs/smartbugs.svg"></a>
<a href="https://github.com/smartbugs/smartbugs/blob/master/LICENSE"><img alt="Smartbugs license" src="https://img.shields.io/github/license/smartbugs/smartbugs.svg?color=blue"></a>
<span class="badge-crypto"><a href="#support-and-donate" title="Donate to this project using Cryptocurrency"><img src="https://img.shields.io/badge/crypto-donate-red.svg" alt="crypto donate button" /></a></span>
<a href="#Supported-Tools"><img alt="analysis tools" src="https://img.shields.io/badge/analysis tools-20-blue"></a>


SmartBugs is an extensible platform with a uniform interface to tools
that analyse blockchain programs for weaknesses and other properties.

## Features

- *20 supported tools, 3 modes* for analysing Solidity source
  code, deployment bytecode, and runtime code.

- *Modular integration of analysers.* All it takes to add
  a new tool is a Docker image encapsulating the tool and a few lines
  in a config file. To make the output accessible in a standardised
  format, add a small Python script.
  
- *Parallel, randomised, restartable execution* of the tasks for the
  optimal use of resources when performing a bulk analysis. If
  execution is interrupted, it can be resumed by running SmartBugs
  with the same parameters again.

- *Standardised output format.* Scripts parse and normalise the output
  of the tools to allow for an automated analysis of the results across
  tools.

- *Automatic download of an appropriate Solidity compiler* matching
  the contract under analysis, and injection into the Docker image.

- *Output of results in SARIF format,* for integration into Github
  workflows.

- *Platform independence:* SmartBugs has been tested with Linux, MacOS
  and Windows.

## Supported Tools

|      | version | Solidity | bytecode | runtime code |
| :--- | :--- | :---: | :---: | :--: |
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
| [Slither](https://github.com/crytic/slither)  | 0.10.4 | :heavy_check_mark: |                    |                    |
| [Smartcheck](https://github.com/smartdec/smartcheck)         |  | :heavy_check_mark: |                    |                    |
| [Solhint](https://github.com/protofire/solhint)         | 3.3.8 | :heavy_check_mark: |                    |                    |
| [teEther](https://github.com/nescio007/teether)      | #04adf56 |                    |                    | :heavy_check_mark: |
| [Vandal](https://github.com/usyd-blockchain/vandal)  | #d2b0043 |                    |                    | :heavy_check_mark: |



## Installation

SmartBugs has been tested with Linux, MacOS and Windows. It depends on
Docker and Python.  For details, see the [installation
instructions](doc/installation.md).

## Usage

SmartBugs provides a uniform command-line interface to all tools.  Two
utilities allow the user to reparse analysis results at any time after
the analysis and to extract the data into a form suitable for a
database.

As an example, the following commands analyse the contracts in the `samples` folder with all available tools and write the parsed output to `results.csv`.

```console
./smartbugs -t all -f samples/* --timeout 600
./reparse results
./results2csv -p results > results.csv
```

For details, see the [usage notes](doc/usage.md) and the [SmartBugs wiki](https://github.com/smartbugs/smartbugs/wiki).

## Smart Contract Datasets

See our [information on available datasets](doc/datasets.md) if you
are looking for input data. The number of contracts
in these datasets ranges from 10 to 250,000.

## Academia: How to Cite

If you use SmartBugs or one of the datasets above, you may want to cite
your sources. See the [list of publications](doc/academia.md) for details.

## Support and Donate
You can show your appreciation for the project and support future development by donating.

**🙌 ETH Donations:** `0xA4FBA2908162646197aca90b84B095BE4D16Ae53` 🙌

## License

The [license](LICENSE) applies to all files in the repository,
with the exception of the smart contracts in the `samples` folder.
The files there were obtained from [Etherscan](http://etherscan.io)
and retain their original licenses.
