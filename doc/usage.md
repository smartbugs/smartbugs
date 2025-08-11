# Usage

SmartBugs provides a command-line interface. Run it without arguments for a short description.
For details, see [SmartBugs' wiki](https://github.com/smartbugs/smartbugs/wiki/The-command-line-interface).


```console
./smartbugs
usage: smartbugs [-c FILE] [-t TOOL [TOOL ...]] [-f PATTERN [PATTERN ...]] [--main] [--runtime]
                 [--processes N] [--timeout N] [--cpu-quota N] [--mem-limit MEM]
                 [--runid ID] [--results DIR] [--log FILE] [--overwrite] [--json] [--sarif] [--quiet] 
                 [--version] [-h]
...
```

**Example:** To analyse the Solidity files in the `samples` directory with Mythril, use the command

```console
./smartbugs -t mythril -f samples/*.sol --processes 2 --mem-limit 4g --timeout 600
```

The options tell SmartBugs to run two processes in parallel, with a memory limit of 4GB and max. 10 minutes computation time per task.
By default, the results are placed in the local directory `results`.

## Utility programs

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
