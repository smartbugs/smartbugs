import json
from pathlib import Path
from typing import Any, Dict, List, Optional, Union

from semantic_version import Version

from solcx import wrapper
from solcx.exceptions import ContractsNotFound, SolcError
from solcx.install import get_executable


def get_solc_version(with_commit_hash: bool = False) -> Version:
    """
    Get the version of the active `solc` binary.

    Arguments
    ---------
    with_commit_hash : bool, optional
        If True, the commit hash is included within the version

    Returns
    -------
    Version
        solc version
    """
    solc_binary = get_executable()
    return wrapper._get_solc_version(solc_binary, with_commit_hash)


def compile_source(
    source: str,
    output_values: List = None,
    import_remappings: Union[Dict, List, str] = None,
    base_path: Union[Path, str] = None,
    allow_paths: Union[List, Path, str] = None,
    output_dir: Union[Path, str] = None,
    overwrite: bool = False,
    evm_version: str = None,
    revert_strings: Union[List, str] = None,
    metadata_hash: str = None,
    metadata_literal: bool = False,
    optimize: bool = False,
    optimize_runs: int = None,
    optimize_yul: bool = False,
    no_optimize_yul: bool = False,
    yul_optimizations: int = None,
    solc_binary: Union[str, Path] = None,
    solc_version: Version = None,
    allow_empty: bool = False,
) -> Dict:
    """
    Compile a Solidity contract.

    Compilation is handled via the `--combined-json` flag. Depending on the solc
    version used, some keyword arguments may not be available.

    Arguments
    ---------
    source: str
        Solidity contract to be compiled.
    output_values : List, optional
        Compiler outputs to return. Valid options depend on the version of `solc`.
        If not given, all possible outputs for the active version are returned.
    import_remappings : Dict | List | str , optional
        Path remappings. May be given as a string or list of strings formatted as
        `"prefix=path"`, or a dict of `{"prefix": "path"}`.
    base_path : Path | str, optional
        Use the given path as the root of the source tree instead of the root
        of the filesystem.
    allow_paths : List | Path | str, optional
        A path, or list of paths, to allow for imports.
    output_dir : str, optional
        Creates one file per component and contract/file at the specified directory.
    overwrite : bool, optional
        Overwrite existing files (used in combination with `output_dir`)
    evm_version: str, optional
        Select the desired EVM version. Valid options depend on the `solc` version.
    revert_strings : List | str, optional
        Strip revert (and require) reason strings or add additional debugging
        information.
    metadata_hash : str, optional
        Choose hash method for the bytecode metadata or disable it.
    metadata_literal : bool, optional
        Store referenced sources as literal data in the metadata output.
    optimize : bool, optional
        Enable bytecode optimizer.
    optimize_runs : int, optional
        Set for how many contract runs to optimize. Lower values will optimize
        more for initial deployment cost, higher values will optimize more for
        high-frequency usage.
    optimize_yul: bool, optional
        Enable the yul optimizer.
    no_optimize_yul : bool, optional
        Disable the yul optimizer.
    yul_optimizations : int, optional
        Force yul optimizer to use the specified sequence of optimization steps
        instead of the built-in one.
    solc_binary : str | Path, optional
        Path of the `solc` binary to use. If not given, the currently active
        version is used (as set by `solcx.set_solc_version`)
    solc_version: Version, optional
        `solc` version to use. If not given, the currently active version is used.
        Ignored if `solc_binary` is also given.
    allow_empty : bool, optional
        If `True`, do not raise when no compiled contracts are returned.

    Returns
    -------
    Dict
        Compiler output. The source file name is given as `<stdin>`.
    """
    return _compile_combined_json(
        solc_binary=solc_binary,
        solc_version=solc_version,
        stdin=source,
        output_values=output_values,
        import_remappings=import_remappings,
        base_path=base_path,
        allow_paths=allow_paths,
        output_dir=output_dir,
        overwrite=overwrite,
        evm_version=evm_version,
        revert_strings=revert_strings,
        metadata_hash=metadata_hash,
        metadata_literal=metadata_literal,
        optimize=optimize,
        optimize_runs=optimize_runs,
        no_optimize_yul=no_optimize_yul,
        yul_optimizations=yul_optimizations,
        allow_empty=allow_empty,
    )


def compile_files(
    source_files: Union[List, Path, str],
    output_values: List = None,
    import_remappings: Union[Dict, List, str] = None,
    base_path: Union[Path, str] = None,
    allow_paths: Union[List, Path, str] = None,
    output_dir: Union[Path, str] = None,
    overwrite: bool = False,
    evm_version: str = None,
    revert_strings: Union[List, str] = None,
    metadata_hash: str = None,
    metadata_literal: bool = False,
    optimize: bool = False,
    optimize_runs: int = None,
    optimize_yul: bool = False,
    no_optimize_yul: bool = False,
    yul_optimizations: int = None,
    solc_binary: Union[str, Path] = None,
    solc_version: Version = None,
    allow_empty: bool = False,
) -> Dict:
    """
    Compile one or more Solidity source files.

    Compilation is handled via the `--combined-json` flag. Depending on the solc
    version used, some keyword arguments may not be available.

    Arguments
    ---------
    source_files: List | Path | str
        Path, or list of paths, of Solidity source files to be compiled.
    output_values : List, optional
        Compiler outputs to return. Valid options depend on the version of `solc`.
        If not given, all possible outputs for the active version are returned.
    import_remappings : Dict | List | str , optional
        Path remappings. May be given as a string or list of strings formatted as
        `"prefix=path"`, or a dict of `{"prefix": "path"}`.
    base_path : Path | str, optional
        Use the given path as the root of the source tree instead of the root
        of the filesystem.
    allow_paths : List | Path | str, optional
        A path, or list of paths, to allow for imports.
    output_dir : str, optional
        Creates one file per component and contract/file at the specified directory.
    overwrite : bool, optional
        Overwrite existing files (used in combination with `output_dir`)
    evm_version: str, optional
        Select the desired EVM version. Valid options depend on the `solc` version.
    revert_strings : List | str, optional
        Strip revert (and require) reason strings or add additional debugging
        information.
    metadata_hash : str, optional
        Choose hash method for the bytecode metadata or disable it.
    metadata_literal : bool, optional
        Store referenced sources as literal data in the metadata output.
    optimize : bool, optional
        Enable bytecode optimizer.
    optimize_runs : int, optional
        Set for how many contract runs to optimize. Lower values will optimize
        more for initial deployment cost, higher values will optimize more for
        high-frequency usage.
    optimize_yul: bool, optional
        Enable the yul optimizer.
    no_optimize_yul : bool, optional
        Disable the yul optimizer.
    yul_optimizations : int, optional
        Force yul optimizer to use the specified sequence of optimization steps
        instead of the built-in one.
    solc_binary : str | Path, optional
        Path of the `solc` binary to use. If not given, the currently active
        version is used (as set by `solcx.set_solc_version`)
    solc_version: Version, optional
        `solc` version to use. If not given, the currently active version is used.
        Ignored if `solc_binary` is also given.
    allow_empty : bool, optional
        If `True`, do not raise when no compiled contracts are returned.

    Returns
    -------
    Dict
        Compiler output
    """
    return _compile_combined_json(
        solc_binary=solc_binary,
        solc_version=solc_version,
        source_files=source_files,
        output_values=output_values,
        import_remappings=import_remappings,
        base_path=base_path,
        allow_paths=allow_paths,
        output_dir=output_dir,
        overwrite=overwrite,
        evm_version=evm_version,
        revert_strings=revert_strings,
        metadata_hash=metadata_hash,
        metadata_literal=metadata_literal,
        optimize=optimize,
        optimize_runs=optimize_runs,
        no_optimize_yul=no_optimize_yul,
        yul_optimizations=yul_optimizations,
        allow_empty=allow_empty,
    )


def _get_combined_json_outputs(solc_binary: Union[Path, str] = None) -> str:
    if solc_binary is None:
        solc_binary = get_executable()

    help_str = wrapper.solc_wrapper(solc_binary=solc_binary, help=True)[0].split("\n")
    combined_json_args = next(i for i in help_str if i.startswith("  --combined-json"))
    return combined_json_args.split(" ")[-1]


def _parse_compiler_output(stdoutdata: str) -> Dict:
    output = json.loads(stdoutdata)

    contracts = output.get("contracts", {})
    sources = output.get("sources", {})

    for path_str, data in contracts.items():
        if "abi" in data and isinstance(data["abi"], str):
            data["abi"] = json.loads(data["abi"])
        key = path_str.rsplit(":", maxsplit=1)[0]
        if "AST" in sources.get(key, {}):
            data["ast"] = sources[key]["AST"]

    return contracts


def _compile_combined_json(
    output_values: Optional[List] = None,
    solc_binary: Union[str, Path, None] = None,
    solc_version: Optional[Version] = None,
    output_dir: Union[str, Path, None] = None,
    overwrite: Optional[bool] = False,
    allow_empty: Optional[bool] = False,
    **kwargs: Any,
) -> Dict:

    if solc_binary is None:
        solc_binary = get_executable(solc_version)

    if output_values is None:
        combined_json = _get_combined_json_outputs(solc_binary)
    else:
        combined_json = ",".join(output_values)

    if output_dir:
        output_dir = Path(output_dir)
        if output_dir.is_file():
            raise FileExistsError("`output_dir` must be as a directory, not a file")
        if output_dir.joinpath("combined.json").exists() and not overwrite:
            target_path = output_dir.joinpath("combined.json")
            raise FileExistsError(
                f"Target output file {target_path} already exists - use overwrite=True to overwrite"
            )

    stdoutdata, stderrdata, command, proc = wrapper.solc_wrapper(
        solc_binary=solc_binary,
        combined_json=combined_json,
        output_dir=output_dir,
        overwrite=overwrite,
        **kwargs,
    )

    if output_dir:
        output_path = Path(output_dir).joinpath("combined.json")
        if stdoutdata:
            output_path.parent.mkdir(parents=True, exist_ok=True)
            with output_path.open("w") as fp:
                fp.write(stdoutdata)
        else:
            with output_path.open() as fp:
                stdoutdata = fp.read()

    contracts = _parse_compiler_output(stdoutdata)

    if not contracts and not allow_empty:
        raise ContractsNotFound(
            command=command,
            return_code=proc.returncode,
            stdout_data=stdoutdata,
            stderr_data=stderrdata,
        )
    return contracts


def compile_standard(
    input_data: Dict,
    base_path: str = None,
    allow_paths: List = None,
    output_dir: str = None,
    overwrite: bool = False,
    solc_binary: Union[str, Path] = None,
    solc_version: Version = None,
    allow_empty: bool = False,
) -> Dict:
    """
    Compile Solidity contracts using the JSON-input-output interface.

    See the Solidity documentation for details on the expected JSON input and output
    formats.

    Arguments
    ---------
    input_data : Dict
        Compiler JSON input.
    base_path : Path | str, optional
        Use the given path as the root of the source tree instead of the root
        of the filesystem.
    allow_paths : List | Path | str, optional
        A path, or list of paths, to allow for imports.
    output_dir : str, optional
        Creates one file per component and contract/file at the specified directory.
    overwrite : bool, optional
        Overwrite existing files (used in combination with `output_dir`)
    solc_binary : str | Path, optional
        Path of the `solc` binary to use. If not given, the currently active
        version is used (as set by `solcx.set_solc_version`)
    solc_version: Version, optional
        `solc` version to use. If not given, the currently active version is used.
        Ignored if `solc_binary` is also given.
    allow_empty : bool, optional
        If `True`, do not raise when no compiled contracts are returned.

    Returns
    -------
    Dict
        Compiler JSON output.
    """
    if not input_data.get("sources") and not allow_empty:
        raise ContractsNotFound(
            "Input JSON does not contain any sources",
            stdin_data=json.dumps(input_data, sort_keys=True, indent=2),
        )

    if solc_binary is None:
        solc_binary = get_executable(solc_version)

    stdoutdata, stderrdata, command, proc = wrapper.solc_wrapper(
        solc_binary=solc_binary,
        stdin=json.dumps(input_data),
        standard_json=True,
        base_path=base_path,
        allow_paths=allow_paths,
        output_dir=output_dir,
        overwrite=overwrite,
    )

    compiler_output = json.loads(stdoutdata)
    if "errors" in compiler_output:
        has_errors = any(error["severity"] == "error" for error in compiler_output["errors"])
        if has_errors:
            error_message = "\n".join(
                tuple(
                    error["formattedMessage"]
                    for error in compiler_output["errors"]
                    if error["severity"] == "error"
                )
            )
            raise SolcError(
                error_message,
                command=command,
                return_code=proc.returncode,
                stdin_data=json.dumps(input_data),
                stdout_data=stdoutdata,
                stderr_data=stderrdata,
                error_dict=compiler_output["errors"],
            )
    return compiler_output


def link_code(
    unlinked_bytecode: str,
    libraries: Dict,
    solc_binary: Union[str, Path] = None,
    solc_version: Version = None,
) -> str:
    """
    Add library addresses into unlinked bytecode.

    Arguments
    ---------
    unlinked_bytecode : str
        Compiled bytecode containing one or more library placeholders.
    libraries : Dict
        Library addresses given as {"library name": "address"}
    solc_binary : str | Path, optional
        Path of the `solc` binary to use. If not given, the currently active
        version is used (as set by `solcx.set_solc_version`)
    solc_version: Version, optional
        `solc` version to use. If not given, the currently active version is used.
        Ignored if `solc_binary` is also given.

    Returns
    -------
    str
        Linked bytecode
    """
    if solc_binary is None:
        solc_binary = get_executable(solc_version)

    library_list = [f"{name}:{address}" for name, address in libraries.items()]

    stdoutdata = wrapper.solc_wrapper(
        solc_binary=solc_binary, stdin=unlinked_bytecode, link=True, libraries=library_list
    )[0]

    return stdoutdata.replace("Linking completed.", "").strip()
