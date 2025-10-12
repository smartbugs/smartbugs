from typing import Optional

from sb.settings import Settings
from sb.tools import Tool


class Task:
    """
    Represents a single analysis task pairing a file with a tool.

    Attributes:
        absfn: Absolute normalized path to the file to analyze
        relfn: Relative path within the project
        rdir: Directory where results will be stored
        solc_version: Solidity compiler version to use (if applicable)
        solc_path: Path to the Solidity compiler binary (if applicable)
        tool: Tool configuration for the analysis
        settings: Global settings for the analysis run
    """

    def __init__(
        self,
        absfn: str,
        relfn: str,
        rdir: str,
        solc_version: Optional[str],
        solc_path: Optional[str],
        tool: Tool,
        settings: Settings,
    ) -> None:
        self.absfn = absfn  # absolute normalized path
        self.relfn = relfn  # path within project
        self.rdir = rdir  # directory for results
        self.solc_version = solc_version
        self.solc_path = solc_path
        self.tool = tool
        self.settings = settings

    def __str__(self) -> str:
        s = [f"{k}: {str(v)}" for k, v in self.__dict__.items()]
        return f"{{{', '.join(s)}}}"
