import codecs
import os
import json
from typing import Any, Union

import yaml

import sb.errors


def read_bin(fn: str | os.PathLike) -> bytes:
    try:
        with open(fn, "rb") as f:
            return f.read()
    except Exception as e:
        raise sb.errors.SmartBugsError(e)


def __read_text(fn: str | os.PathLike) -> str:
    with open(fn, "rb") as f:
        raw = f.read()

    # BOM detection
    if raw.startswith(codecs.BOM_UTF8):
        return raw.decode("utf-8-sig")
    if raw.startswith(codecs.BOM_UTF16_LE) or raw.startswith(codecs.BOM_UTF16_BE):
        return raw.decode("utf-16")

    # Heuristic: UTF16 without BOM
    # maybe add a CLI option to activate this, if needed at all
    # if len(raw) >= 2:
    #    even_nulls = sum(1 for i in range(0, len(raw), 2) if raw[i] == 0)
    #    odd_nulls  = sum(1 for i in range(1, len(raw), 2) if raw[i] == 0)
    #    threshold = len(raw) // 4
    #    if even_nulls > threshold or odd_nulls > threshold:
    #        try:
    #            return raw.decode("utf-16")
    #        except UnicodeDecodeError:
    #            pass

    # Default: UTF8
    return raw.decode("utf-8")


def read_text(fn: str | os.PathLike) -> str:
    try:
        return __read_text(fn)
    except Exception as e:
        raise sb.errors.SmartBugsError(e)


def read_lines(fn: str | os.PathLike) -> list[str]:
    try:
        return __read_text(fn).splitlines()
    except Exception as e:
        raise sb.errors.SmartBugsError(e)


def read_yaml(fn: str | os.PathLike) -> dict[str, Any]:
    try:
        return yaml.safe_load(__read_text(fn)) or {}
    except Exception as e:
        raise sb.errors.SmartBugsError(e)


def read_json(fn: str | os.PathLike) -> Any:
    try:
        return json.loads(__read_text(fn))
    except Exception as e:
        raise sb.errors.SmartBugsError(e)


def write_bin(fn: str | os.PathLike, output: bytes) -> None:
    try:
        with open(fn, "wb") as f:
            f.write(output)
    except Exception as e:
        raise sb.errors.SmartBugsError(e)


def write_text(fn: str | os.PathLike, output: Union[str, list[str]]) -> None:
    try:
        with open(fn, "w", encoding="utf-8") as f:
            if isinstance(output, str):
                f.write(output)
            else:
                for line in output:
                    f.write(f"{line}\n")
    except Exception as e:
        raise sb.errors.SmartBugsError(e)


def write_json(fn: str | os.PathLike, output: Any) -> None:
    try:
        j = json.dumps(output, sort_keys=True, indent=4)
        with open(fn, "w", encoding="utf-8") as f:
            print(j, file=f)
    except Exception as e:
        raise sb.errors.SmartBugsError(e)
