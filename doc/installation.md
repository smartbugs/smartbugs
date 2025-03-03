# Installation

## Requirements

- Linux, MacOS or Windows
- [Docker](https://docs.docker.com/install)
- [Python3](https://www.python.org) (version 3.6 and above, 3.10+ recommended)

## Linux/MacOS/Unix

1. Install  [Docker](https://docs.docker.com/install) and [Python3](https://www.python.org).

   Make sure that the user running SmartBugs has permission to interact with the Docker daemon, by adding the user to the `docker` group:

   ```bash
   sudo usermod -a -G docker $USER
   ```

   For adding someone else, replace `$USER` by the respective
   user-id. The group membership becomes active with the next log-in.

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


## Windows

See [our wiki page on running SmartBugs in Windows](https://github.com/smartbugs/smartbugs/wiki/Running-SmartBugs-in-Windows).

