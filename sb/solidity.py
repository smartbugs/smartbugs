import re
from typing import Union

VOID_START: re.Pattern[str] = re.compile("//|/\\*|\"|'")
QUOTE_END: re.Pattern[str] = re.compile("(?<!\\\\)'")
DQUOTE_END: re.Pattern[str] = re.compile('(?<!\\\\)"')


def remove_comments_strings(program: str) -> str:
    """Return program without Solidity comments and strings

    :param str program: Solidity program as a list of lines
    :return: program with strings emptied and comments removed
    :rtype: str
    """
    result = ""
    while True:
        match_start_of_void = VOID_START.search(program)
        if not match_start_of_void:
            result += program
            break
        else:
            result += program[: match_start_of_void.start()]
            if match_start_of_void[0] == "//":
                end = program.find("\n", match_start_of_void.end())
                program = "" if end == -1 else program[end:]
            elif match_start_of_void[0] == "/*":
                end = program.find("*/", match_start_of_void.end())
                nls = program[match_start_of_void.end() : end].count("\n")
                result += "\n" * nls if nls > 0 else " "
                program = "" if end == -1 else program[end + 2 :]
            else:
                if match_start_of_void[0] == "'":
                    match_end_of_string = QUOTE_END.search(program[match_start_of_void.end() :])
                    result += "''"
                else:
                    match_end_of_string = DQUOTE_END.search(program[match_start_of_void.end() :])
                    result += '""'
                if not match_end_of_string:  # unclosed string
                    break
                program = program[match_start_of_void.end() + match_end_of_string.end() :]
    return result


def remove_strings(program: str) -> str:
    """Return program without Solidity strings

    :param str program: Solidity program as a list of lines
    :return: program with strings emptied
    :rtype: str
    """
    result = ""
    while True:
        match_start_of_void = VOID_START.search(program)
        if not match_start_of_void:
            result += program
            break
        else:
            if match_start_of_void[0] == "//":
                end = program.find("\n", match_start_of_void.end())
                result += program if end == -1 else program[: end + 1]
                program = "" if end == -1 else program[end + 1 :]
            elif match_start_of_void[0] == "/*":
                end = program.find("*/", match_start_of_void.end())
                result += program if end == -1 else program[: end + 2]
                program = "" if end == -1 else program[end + 2 :]
            else:
                result += program[: match_start_of_void.start()]
                if match_start_of_void[0] == "'":
                    match_end_of_string = QUOTE_END.search(program[match_start_of_void.end() :])
                    result += "''"
                else:
                    match_end_of_string = DQUOTE_END.search(program[match_start_of_void.end() :])
                    result += '""'
                if not match_end_of_string:  # unclosed string
                    break
                program = program[match_start_of_void.end() + match_end_of_string.end() :]
    return result


PRAGMA: re.Pattern[str] = re.compile(r"pragma\s+solidity\s*(.*?);")
CONTRACT_NAMES: re.Pattern[str] = re.compile(
    r"(?:contract|library)\s+([A-Za-z0-9_]*)(?:\s*{|\s+is\s)"
)


def extract_versions_contractnames(program: Union[str, list[str]]) -> tuple[list[str], list[str]]:

    # normalise line ends
    if isinstance(program, str):
        program = program.splitlines()
    program = "\n".join(program)

    program_wo_comments_strings = remove_comments_strings(program)
    versions = PRAGMA.findall(program_wo_comments_strings)

    if not versions:
        program_wo_strings = remove_strings(program)
        versions = PRAGMA.findall(program_wo_strings)
        if versions:
            versions = [versions[0]]  # first version from comments

    contractnames = CONTRACT_NAMES.findall(program_wo_comments_strings)

    return versions, contractnames
