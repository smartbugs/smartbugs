import json
from pathlib import Path
from typing import Any, Union

import yaml

import sb.errors


def read_yaml(fn: Union[str, Path]) -> dict[str, Any]:
    try:
        with open(fn, encoding="utf-8") as f:
            # for an empty file, return empty dict, not NoneType
            return yaml.safe_load(f) or {}
    except Exception as e:
        raise sb.errors.SmartBugsError(e)


def read_json(fn: Union[str, Path]) -> Any:
    try:
        with open(fn, encoding="utf-8") as f:
            return json.load(f)
    except Exception as e:
        raise sb.errors.SmartBugsError(e)


def write_json(fn: Union[str, Path], output: Any) -> None:
    try:
        j = json.dumps(output, sort_keys=True, indent=4)
        with open(fn, "w", encoding="utf-8") as f:
            print(j, file=f)
    except Exception as e:
        raise sb.errors.SmartBugsError(e)


def read_lines(fn: Union[str, Path]) -> list[str]:
    try:
        with open(fn, encoding="utf-8") as f:
            return f.read().splitlines()
    except Exception as e:
        raise sb.errors.SmartBugsError(e)


def write_txt(fn: Union[str, Path], output: Union[str, list[str]]) -> None:
    try:
        with open(fn, "w", encoding="utf-8") as f:
            if isinstance(output, str):
                f.write(output)
            else:
                for line in output:
                    f.write(f"{line}\n")
    except Exception as e:
        raise sb.errors.SmartBugsError(e)


def read_bin(fn: Union[str, Path]) -> bytes:
    try:
        with open(fn, "rb") as f:
            return f.read()
    except Exception as e:
        raise sb.errors.SmartBugsError(e)


def write_bin(fn: Union[str, Path], output: bytes) -> None:
    try:
        with open(fn, "wb") as f:
            f.write(output)
    except Exception as e:
        raise sb.errors.SmartBugsError(e)
