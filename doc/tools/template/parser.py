import sb.parse_utils # for sb.parse_utils.init(...)
import io, tarfile    # if the output parameter is used
import ...            # any further imports

VERSION: str = ...
"""identify the version of the parser, e.g. '2022/08/15'"""

FINDINGS: set[str]  = ...
"""set of strings: all possible findings, of which 'findings' below will be a subset"""


def parse(exit_code, log, output, task):
    """
    Analyse the result of the tool tun.

    :param exit_code: int|None, exit code of Docker run (None=timeout)
    :param log: list[str], stdout/stderr of Docker run
    :param output: bytes, tar archive of files generated by the tool (if specified in config.yaml)
    :param task: dict, contents of smartbugs.json, meta-data of the run (like time)

    :return: tuple[findings: set[str], infos: set[str], errors: set[str], fails: set[str], analysis: Any]
      findings identifies the major observations of the tool,
      infos contains any messages generated by the tool that might be of interest,
      errors lists the error messages deliberately generated by the tool,
      fails lists exceptions and other events not expected by the tool,
      analysis contains any analysis results worth reporting
    """

    findings, infos, analysis = set(), set(), None
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)
    # Parses the output for common Python/Java/shell exceptions (returned in 'fails')

    for line in log:
        # analyse stdout/stderr of the Docker run
        ...

    try:
        with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:
            contents_of_some_file = tar.extractfile("name_of_some_file").read()
        # process contents_of_some_file
        ...
    except Exception as e:
        fails.add("error parsing results: {e}")

    return findings, infos, errors, fails, analysis

