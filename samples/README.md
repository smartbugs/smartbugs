# Sample Contracts

Folder `0.4.x` contains 10 'real-world' contracts from Ethereum's main chain. They are a subset of the [SmartBugs Curated Dataset](https://github.com/smartbugs/smartbugs-curated). The bytecode is the one deployed on the blockchain. For details about the compiler settings for generating it from the source code, see [Etherscan](https://etherscan.com).

The folders `0.5.17`, `0.6.12`, `0.7.6`, and `0.8.24` contain the same contracts but adapted to the respective Solidity version. The bytecodes were obtained by compiling the source code without additional flags.

## Running a tool on all samples

To run a tool (here Mythril) on all samples, use a command like
```bash
./smartbugs -t mythril -f samples:**/* --results 'results/${TOOL}/${RELDIR}/${FILENAME}' --timeout 300 --processes 4 --mem-limit 2g
```
The pattern `**/*` picks all files in all subfolders of `samples`. The colon after `samples` acts like a slash, but indicates that the part before the colon, `samples`, should not be part of `RELDIR`.
The costum value for `--results` ensures that there are no name clashes for contracts with the same name for different Solidity versions. The default value of `--results` does not use `RELDIR` as distinguishing feature, therefore SmartBugs would append numbers to `FILENAME` to resolve name clashes.