from typing import Dict, List


class SolcError(Exception):
    message = "An error occurred during execution"

    def __init__(
        self,
        message: str = None,
        command: List = None,
        return_code: int = None,
        stdin_data: str = None,
        stdout_data: str = None,
        stderr_data: str = None,
        error_dict: Dict = None,
    ) -> None:
        if message is not None:
            self.message = message
        self.command = command or []
        self.return_code = return_code
        self.stdin_data = stdin_data
        self.stderr_data = stderr_data
        self.stdout_data = stdout_data
        self.error_dict = error_dict

    def __str__(self) -> str:
        return (
            f"{self.message}"
            f"\n> command: `{' '.join(str(i) for i in self.command)}`"
            f"\n> return code: `{self.return_code}`"
            "\n> stdout:"
            f"\n{self.stdout_data}"
            "\n> stderr:"
            f"\n{self.stderr_data}"
        ).strip()


class ContractsNotFound(SolcError):
    message = "No contracts found during compilation"


class SolcInstallationError(Exception):
    pass


class UnknownOption(AttributeError):
    pass


class UnknownValue(ValueError):
    pass


class UnexpectedVersionError(Exception):
    pass


class UnsupportedVersionError(ValueError):
    pass


class SolcNotInstalled(Exception):
    pass


class DownloadError(Exception):
    pass


class UnexpectedVersionWarning(Warning):
    pass
