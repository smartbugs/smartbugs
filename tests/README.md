# Testing Smartbugs

The test framework consists of a script `run.sh` to process sample contracts with a specific version of Smartbugs,
and a script `diff.sh` to compare the output of two runs, filtering noise.

## Running a Specific Version of Smartbugs on Sample Contracts

```console
./run.sh CMD SAMPLE [COMMIT]
```
runs the script `CMD` on the contracts in `SAMPLE`, using version `COMMIT` of Smartbugs.
Without `COMMIT`, `run.sh` uses Smartbugs as given by the current state of the repo, typically the top of the branch.
The output of the run is copied to the directory `runs/CMD-SAMPLE-COMMIT` or `runs/CMD-SAMPLE`, respectively.

### Scripts

The directory `cmds` contains two scripts.

- `cmds/solidity1` runs Smartbugs from its home directory, as required by older versions of Smartbugs. As input, Smartbugs expects Solidity source code.

- `cmds/solidity2` runs Smartbugs from the `tests` directory below the home directory and verifies, as a side effect, that Smartbugs finds all its files.
  As input, Smartbugs expects Solidity source code.

### Contract samples

The directory `samples` contains the following datasets.

- `samples/curated`: a collection of 69 contracts used in the paper "Empirical Review of Automated Analysis Tools on 47,587 Ethereum Smart Contracts".
  As a reference, the results of Smartbugs from this paper run on `curated` can be found in `runs/icse2020`.

- `samples/1` contains a single contract, `FindThisHash.sol`. This dataset is intended for quickly checking whether the test framework and Smartbugs works.

- `samples/10` contains 10 contracts randomly selected from `samples/curated`.

### Examples

- Run the current branch on the set of 10 sample contracts. The output will be in directory `runs/solidity2-10`.
```console
./run.sh cmds/solidity2 samples/10
```

- Run commit `6d23825` of Smartbugs on the set of 10 sample contracts. This version has to be run from Smartbugs' home directory, therefore we have to use
  the script `solidity1`. The output ends up in directory `runs/solidity1-10-6d23825`.
```console
./run.sh cmds/solidity1 samples/10 6d23825
```

## Comparing the Output of Different Versions of Smartbugs

```console
./diff.sh RUN1 RUN2 | less
```
compares the output of RUN1 to the output of RUN2 (and pipes it through `less`). More precisely:

- The script identifies the contracts common to both contract samples.

- For each of the common contracts, it identifies the file names occurring in the output of both contracts.

- For each of the common files, `diff.sh` checks whether there is a filter in subdirectory `filters`.
  If yes, the files are piped through the filter and its output is used instead of the file.
  The purpose of the filters is to remove parts that change with every run, in order to restrict differences to relevant ones.

- Finally, the script uses `diff` to compare the (filtered) files.

Note that the output of the tools is not completely deterministic, e.g. due to timing issues.
Therefore we do not necessarily obtain identical output from identical input.

### Filters

The files in the output of a run are identified by a path of the form `TOOL/contract/FILE.EXT`.
When processing such a file, `diff.sh` first looks for a filter `filters/TOOL-FILE-EXT`.
If it does not exist, then `diff.sh` looks for `filters/FILE-EXT`.
If this file does not exist either, then `TOOL/contract/FILE.EXT` is diff'ed unchanged.

### Examples

```console
./diff.sh runs/solidity1-10-6d23825 runs/solidity2-10
```
compares the output of Smartbugs, commit `6d23825`, to the output of the current Smartbugs.

```console
./diff.sh runs/icse2020 runs/solidity2-10
```
compares the historic data from the conference ICSE2020 to the output of the current Smartbugs.
