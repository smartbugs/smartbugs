# SmartBugs: A Dataset of Vulnerable Solidity Smart Contracts
SmartBugs is a dataset for research in automated reasoning and testing of smart contracts written in Solidity, the primary language used in Ethereum. The key new idea that SmartBugs proposes is that a reproducible dataset for automated analysis of smart contracts should also provide the possibility to integrate tools easily, so that they can be automatically compared (and their results reproduced). To the best of our knowledge, SmartBugs is the first dataset to provide this facility.

SmartBugs is publicly available as a [GitHub repository](https://github.com/smartbugs/smartbugs).

## Features

 - Organized collection of vulnerable Solidity smart contracts (organized according to the [DASP taxonomy](https://dasp.co))
 - Users can create _named sets_, which are intended to represent subsets of contracts that share a common property. For example, a named dataset already provided by SmartBugs is `reentrancy`: it corresponds to contracts that are vulnerable to reentrancy attacks
 - Users can easily integrate new analysis tools and use SmartBugs' interface to run them. Tools available include [oyente](https://github.com/melonproject/oyente), [mythril](https://github.com/ConsenSys/mythril), [securify](https://github.com/eth-sri/securify), and [smartcheck](https://github.com/smartdec/smartcheck)
 - SmartBugs provides an interface that allows users to query the dataset and run different analysis tools on sets of contracts. 


## Requirements
The first step is to clone [SmartBugs's repository](https://github.com/smartbugs/smartbugs):

```
git clone https://github.com/smartbugs/smartbugs.git
```

SmartBugs requires [Python3](https://www.python.org). To install all the requirements, you can execute:

```
pip3 install -r requirements.txt
```


## Usage
SmartBugs provides a command-line interface that can be used as follows:
```
smartBugs.py [-h, --help]
             (--file FILES | --type TYPE) 
              --tool TOOLS 
              --info TOOLS 
              --list tools types
````

For example, we can analyse all contracts labelled with type `reentrancy` with the tool oyente by executing:

```
python3 smartBugs.py --tool oyente --type reentrancy
```

By default, results will be placed in the directory `results`. 


### Adding your tool or any third-party tool to SmartBugs

You will need to add a configuration file in `config/tools` and define the docker image to use and command to run. The config file should follow a structure similar to the following:
  ```
  docker_image:
    default: primary docker image [REQUIRED]
    solc<5: [OPTIONAL]
  cmd: command to run analysis [REQUIRED]
  info: info about the tool [OPTIONAL]

  output_in_files:
    folder: if the tool does not log results in console, you should provide the path file inside the docker image to get the results [OPTIONAL]
  ```
Please check the provided config files for more concrete examples.


### Adding new named sets 

To add a new named set, edit the configuration file `dataset.yml` (in the folder `config/dataset`) and add the named path you want (can be files or dirs):

The config file should follow a structure similar to:
  ```
  type_1: PATH
  type_2:
        - PATH
        - PATH
  ```
Please check the provided config files for more concrete examples.

## Known limitations

When running a tool the user must be aware of the solc compatibility. Due to the major changes introduced in solidity v0.5.0, we provide the option to pass another docker image to run contracts with solidity version below v0.5.0. However, please note that there may still be problems with the solidity compiler when compiling older versions of solidity code. 

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


## Contributing to SmartBugs
♺ We welcome contributions to the development of SmartBugs. 

The easiest way is to create a pull request. We suggest you follow this guide: [Commit Message Guidelines](https://gist.github.com/robertpainsi/b632364184e70900af4ab688decf6f53).
