import os
import string
import time
from pathlib import Path
from typing import Any, Optional, Union

import sb.cfg
import sb.errors
import sb.io
import sb.logging

NOW = time.gmtime()  # only use in main process, value may be different in sub-processes
PID = os.getpid()  # only use in main process, value may be different in sub-processes


class Settings:

    def __init__(self) -> None:
        self.frozen: bool = False
        self.files: list[tuple[Optional[str], str]] = []
        self.main: bool = False
        self.runtime: bool = False
        self.tools: list[str] = []
        self.runid: str = "${YEAR}${MONTH}${DAY}_${HOUR}${MIN}"
        self.overwrite: bool = False
        self.processes: int = 1
        self.timeout: Optional[int] = None
        self.cpu_quota: Optional[int] = None
        self.mem_limit: Optional[str] = None
        self.continue_on_errors: bool = False
        # Note: results changes type from str to string.Template after freeze()
        self.results: Union[str, string.Template] = os.path.join(
            "results", "${TOOL}", "${RUNID}", "${FILENAME}"
        )
        self.log: str = os.path.join("results", "logs", "${RUNID}.log")
        self.json: bool = False
        self.sarif: bool = False
        self.quiet: bool = False

    def freeze(self) -> None:
        """Freeze settings and expand all template variables.

        Converts runid and log to final values, and converts results to a Template
        for later substitution with tool/file-specific variables.
        """
        if self.frozen:
            return
        self.frozen = True
        env = {
            "SBVERSION": sb.cfg.SB_VERSION,
            "SBHOME": sb.cfg.SB_HOME,
            "HOME": sb.cfg.HOME,
            "PID": PID,
            "YEAR": str(NOW.tm_year).zfill(4),  # year with century, four digits
            "MONTH": str(NOW.tm_mon).zfill(2),  # month 01..12
            "DAY": str(NOW.tm_mday).zfill(2),  # day of month 01..31
            "HOUR": str(NOW.tm_hour).zfill(2),  # hour 00..23
            "MIN": str(NOW.tm_min).zfill(2),  # minutes 00..59
            "SEC": str(NOW.tm_sec).zfill(2),  # seconds 00..61
            "ZONE": NOW.tm_zone,  # abbreviation of timezone name
        }

        try:
            self.runid = string.Template(self.runid).substitute(env)
        except KeyError as e:
            raise sb.errors.SmartBugsError(f"Unknown variable '{e}' in run id")

        try:
            self.log = string.Template(self.log).substitute(env, RUNID=self.runid)
        except KeyError as e:
            raise sb.errors.SmartBugsError(f"Unknown variable '{e}' in name of log file")

        self.results = string.Template(self.results).safe_substitute(  # type: ignore[arg-type]
            env, RUNID=self.runid
        )
        # Convert results path to Template for later substitution with tool/file-specific vars
        self.results = string.Template(self.results)  # type: ignore[assignment]

    def resultdir(self, toolid: str, toolmode: str, absfn: str, relfn: str) -> str:
        """Generate result directory path for a specific tool and file.

        Args:
            toolid: Tool identifier
            toolmode: Tool mode (solidity/bytecode/runtime)
            absfn: Absolute file path
            relfn: Relative file path

        Returns:
            Path to result directory with all template variables substituted
        """
        if not self.frozen:
            raise sb.errors.InternalError(
                "Template of result directory is accessed before settings have been frozen"
            )
        absdir, filename = os.path.split(absfn)
        reldir = os.path.dirname(relfn)
        filebase, fileext = os.path.splitext(filename)
        fileext = fileext.replace(".", "")
        try:
            return self.results.substitute(  # type: ignore[union-attr]
                TOOL=toolid,
                MODE=toolmode,
                ABSDIR=absdir,
                RELDIR=reldir,
                FILENAME=filename,
                FILEBASE=filebase,
                FILEEXT=fileext,
            )
        except KeyError as e:
            raise sb.errors.SmartBugsError(f"unknown variable '{e}' in template of result dir")

    def update(self, settings: Union[str, dict[str, Any], None]) -> None:
        """Update settings from a YAML file path or dictionary.

        Args:
            settings: Path to YAML config file, dictionary of settings, or None
        """
        if self.frozen:
            raise sb.errors.InternalError("frozen settings cannot be updated")
        if not settings:
            return
        if isinstance(settings, str) or isinstance(settings, Path):
            s = sb.io.read_yaml(settings)
        else:
            s = settings
        if not isinstance(s, dict):
            raise sb.errors.SmartBugsError(
                f"settings cannot be updated by objects of type {type(settings).__name__}"
            )

        for k, v in s.items():
            k = k.replace("-", "_")

            # attributes accepting None as a value
            if k in ("timeout", "cpu_quota", "mem_limit") and v in (None, 0, "0"):
                setattr(self, k, None)

            elif k in ("timeout", "cpu_quota", "processes"):
                try:
                    v = int(v)
                    assert v > 0
                    setattr(self, k, v)
                except Exception:
                    raise sb.errors.SmartBugsError(
                        f"setting {k}: positive integer expected, '{v}' found"
                    )

            elif k in ("tools"):
                if not isinstance(v, list):
                    v = [v]
                if any(isinstance(vi, str) for vi in v):
                    setattr(self, k, v)
                else:
                    raise sb.errors.SmartBugsError(
                        f"setting {k}: (list of) string(s) expected, '{v}' found"
                    )

            elif k in ("files"):
                if not isinstance(v, list):
                    v = [v]
                if not any(isinstance(vi, str) for vi in v):
                    raise sb.errors.SmartBugsError(
                        f"setting {k}: (list of) string(s) expected, '{v}' found"
                    )
                root_specs = []
                for vi in v:
                    try:
                        pattern = string.Template(vi).substitute(HOME=sb.cfg.HOME)
                    except KeyError as e:
                        raise sb.errors.SmartBugsError(
                            f"unknown variable '{e}' in file specification"
                        )
                    root_spec = pattern.split(":")
                    if len(root_spec) == 1:
                        root, spec = None, root_spec[0]
                    elif len(root_spec) == 2:
                        root, spec = root_spec[0], root_spec[1]
                    else:
                        raise sb.errors.SmartBugsError(
                            f"file pattern '{pattern}' contains more than one colon"
                        )
                    root_specs.append((root, spec))
                setattr(self, k, root_specs)

            elif k in (
                "main",
                "runtime",
                "overwrite",
                "quiet",
                "json",
                "sarif",
                "continue_on_errors",
            ):
                try:
                    assert isinstance(v, bool)
                    setattr(self, k, v)
                except Exception:
                    raise sb.errors.SmartBugsError(f"setting {k}: Boolean expected, '{v}' found")

            elif k in ("results", "log"):
                if isinstance(v, str):
                    setattr(self, k, v.replace("/", os.path.sep))
                else:
                    raise sb.errors.SmartBugsError(f"setting {k}: path expected, '{v}' found")

            elif k in ("runid"):
                if isinstance(v, str):
                    setattr(self, k, v)
                else:
                    raise sb.errors.SmartBugsError(f"setting {k}: string expected, '{v}' found")

            elif k == "mem_limit":
                try:
                    v = str(v).replace(" ", "")
                    if v[-1] in "kKmMgG":
                        assert int(v[:-1]) > 0
                    else:
                        assert int(v) > 0
                    setattr(self, k, v)
                except Exception:
                    raise sb.errors.SmartBugsError(
                        f"setting {k}: memory spec expected, '{v}' found"
                    )

            else:
                raise sb.errors.SmartBugsError(f"invalid key '{k}' in settings")

    def dict(self) -> dict[str, Any]:
        """Convert settings to dictionary representation.

        Returns:
            Dictionary of settings (excluding 'frozen', with results.template if applicable)
        """
        d: dict[str, Any] = {}
        for k, v in self.__dict__.items():
            if k == "frozen":
                continue
            elif k == "results" and v and not isinstance(v, str):
                d[k] = self.results.template  # type: ignore[union-attr]
            else:
                d[k] = v
        return d

    def __str__(self) -> str:
        items = [f"{k}: {str(v)}" for k, v in self.dict().items()]
        return f"{{{', '.join(items)}}}"
