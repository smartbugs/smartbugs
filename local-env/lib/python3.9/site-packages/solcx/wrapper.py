import re
import subprocess
from pathlib import Path
from typing import Any, Dict, List, Tuple, Union

from semantic_version import Version

from solcx import install
from solcx.exceptions import SolcError, UnknownOption, UnknownValue

# (major.minor.patch)(nightly)(commit)
VERSION_REGEX = r"(\d+\.\d+\.\d+)(?:-nightly.\d+.\d+.\d+|)(\+commit.\w+)"


def _get_solc_version(solc_binary: Union[Path, str], with_commit_hash: bool = False) -> Version:
    # private wrapper function to get `solc` version
    stdout_data = subprocess.check_output([str(solc_binary), "--version"], encoding="utf8")
    try:
        match = next(re.finditer(VERSION_REGEX, stdout_data))
        version_str = "".join(match.groups())
    except StopIteration:
        raise SolcError("Could not determine the solc binary version")

    version = Version.coerce(version_str)
    if with_commit_hash:
        return version
    else:
        return version.truncate()


def _to_string(key: str, value: Any) -> str:
    # convert data into a string prior to calling `solc`
    if isinstance(value, (int, str)):
        return str(value)
    elif isinstance(value, Path):
        return value.as_posix()
    elif isinstance(value, (list, tuple)):
        return ",".join(_to_string(key, i) for i in value)
    else:
        raise TypeError(f"Invalid type for {key}: {type(value)}")


def solc_wrapper(
    solc_binary: Union[Path, str] = None,
    stdin: str = None,
    source_files: Union[List, Path, str] = None,
    import_remappings: Union[Dict, List, str] = None,
    success_return_code: int = None,
    **kwargs: Any,
) -> Tuple[str, str, List, subprocess.Popen]:
    """
    Wrapper function for calling to `solc`.

    Arguments
    ---------
    solc_binary : Path | str, optional
        Location of the `solc` binary. If not given, the current default binary is used.
    stdin : str, optional
        Input to pass to `solc` via stdin
    source_files : list | Path | str, optional
        Path, or list of paths, of sources to compile
    import_remappings : Dict | List | str,  optional
        Path remappings. May be given as a string or list of strings formatted as `"prefix=path"`
        or a dict of `{"prefix": "path"}`
    success_return_code : int, optional
        Expected exit code. Raises `SolcError` if the process returns a different value.

    Keyword Arguments
    -----------------
    **kwargs : Any
        Flags to be passed to `solc`. Keywords are converted to flags by prepending `--` and
        replacing `_` with `-`, for example the keyword `evm_version` becomes `--evm-version`.
        Values may be given in the following formats:

            * `False`, `None`: ignored
            * `True`: flag is used without any arguments
            * str: given as an argument without modification
            * int: given as an argument, converted to a string
            * Path: converted to a string via `Path.as_posix()`
            * List, Tuple: elements are converted to strings and joined with `,`

    Returns
    -------
    str
        Process `stdout` output
    str
        Process `stderr` output
    List
        Full command executed by the function
    Popen
        Subprocess object used to call `solc`
    """
    if solc_binary:
        solc_binary = Path(solc_binary)
    else:
        solc_binary = install.get_executable()

    solc_version = _get_solc_version(solc_binary)
    command: List = [str(solc_binary)]

    if success_return_code is None:
        success_return_code = 1 if "help" in kwargs else 0

    if source_files is not None:
        if isinstance(source_files, (str, Path)):
            command.append(_to_string("source_files", source_files))
        else:
            command.extend([_to_string("source_files", i) for i in source_files])

    if import_remappings is not None:
        if isinstance(import_remappings, str):
            command.append(import_remappings)
        else:
            if isinstance(import_remappings, dict):
                import_remappings = [f"{k}={v}" for k, v in import_remappings.items()]
            command.extend(import_remappings)

    for key, value in kwargs.items():
        if value is None or value is False:
            continue

        key = f"--{key.replace('_', '-')}"
        if value is True:
            command.append(key)
        else:
            command.extend([key, _to_string(key, value)])

    if "standard_json" not in kwargs and not source_files:
        # indicates that solc should read from stdin
        command.append("-")

    if stdin is not None:
        stdin = str(stdin)

    proc = subprocess.Popen(
        command,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        encoding="utf8",
    )

    stdoutdata, stderrdata = proc.communicate(stdin)

    if proc.returncode != success_return_code:
        if stderrdata.startswith("unrecognised option"):
            # unrecognised option '<FLAG>'
            flag = stderrdata.split("'")[1]
            raise UnknownOption(f"solc {solc_version} does not support the '{flag}' option'")
        if stderrdata.startswith("Invalid option"):
            # Invalid option to <FLAG>: <OPTION>
            flag, option = stderrdata.split(": ")
            flag = flag.split(" ")[-1]
            raise UnknownValue(
                f"solc {solc_version} does not accept '{option}' as an option for the '{flag}' flag"
            )

        raise SolcError(
            command=command,
            return_code=proc.returncode,
            stdin_data=stdin,
            stdout_data=stdoutdata,
            stderr_data=stderrdata,
        )

    return stdoutdata, stderrdata, command, proc
