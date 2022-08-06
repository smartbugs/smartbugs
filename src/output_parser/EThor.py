import re
import src.output_parser.Parser as Parser
from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, \
    parseLogicalLocation, isNotDuplicateLogicalLocation

FINDINGS = (
    re.compile(".* (secure|insecure|unknown)$"),
)

MESSAGES = (
#    re.compile("(Integer [0-9]+ does not correspond to opcode)"),
    re.compile("(Encountered an unknown bytecode)"),
)

ERRORS = (
)

FAILS = (
    re.compile("OpenJDK.* failed; error='([^']+)'"),
    re.compile("(Floating-point arithmetic exception) signal in rule"),
    re.compile(".*(Undefined relation [a-zA-Z0-9]+) in file .*dl at line"),
)

UNSUPPORTED_OP = re.compile(".*(java.lang.UnsupportedOperationException: [^)]*)\)")

class EThor(Parser.Parser):
    NAME = "ethor"
    VERSION = "2022/08/06"
    PORTFOLIO = { "secure", "insecure" }

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)

        self._errors.discard('EXIT_CODE_1') # redundant: exit code 1 is reflected in other errors
        if 'DOCKER_TIMEOUT' in self._fails or 'DOCKER_KILL_OOM' in self._fails:
            self._fails.discard('exception (Killed)')
        # Unsupported Ops are regular, checked-for errors, not unexpected fails
        for e in list(self._fails):
            if m := UNSUPPORTED_OP.match(e):
                self._fails.remove(e)
                self._errors.add(m[1])

        for line in self._lines:
            if Parser.add_match(self._findings, line, FINDINGS):
                continue
            if Parser.add_match(self._messages, line, MESSAGES):
                continue
            if Parser.add_match(self._errors, line, ERRORS):
                continue
            if Parser.add_match(self._fails, line, FAILS):
                continue
        if "DOCKER_SEGV" in self._fails:
            self._fails.discard("exception (Segmentation fault)")

        if self._lines and not self._findings:
            self._messages.add('analysis incomplete')
            if not self._fails and not self._errors:
                self._fails.add('execution failed')
        self._findings.discard("unknown")
        self._analysis = sorted(self._findings)


    ## TODO: Sarif
    def parseSarif(self, conkas_output_results, file_path_in_repo):
        resultsList = []
        rulesList = []
        logicalLocationsList = []

        for analysis_result in conkas_output_results["analysis"]:
            rule = parseRule(tool="conkas", vulnerability=analysis_result["vuln_type"])

            logicalLocation = parseLogicalLocation(analysis_result["maybe_in_function"], kind="function")

            result = parseResult(tool="conkas", vulnerability=analysis_result["vuln_type"], uri=file_path_in_repo,
                                 line=int(analysis_result["line_number"]),
                                 logicalLocation=logicalLocation)

            resultsList.append(result)

            if isNotDuplicateRule(rule, rulesList):
                rulesList.append(rule)

            if isNotDuplicateLogicalLocation(logicalLocation, logicalLocationsList):
                logicalLocationsList.append(logicalLocation)

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="Conkas", version="1.0.0", rules=rulesList,
                                         information_uri="https://github.com/nveloso/conkas",
                                         full_description=MultiformatMessageString(
                                             text="Conkas is based on symbolic execution, determines which inputs cause which program branches to execute, to find potential security vulnerabilities. Conkas uses rattle to lift bytecode to a high level representation.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run
