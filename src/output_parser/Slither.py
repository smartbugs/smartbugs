if __name__ == '__main__':
    import sys
    sys.path.append("../..")


import os,json,tarfile
from sarif_om import Tool, ToolComponent, Run, MultiformatMessageString, Location, PhysicalLocation, ArtifactLocation, Region, LogicalLocation, ArtifactContent
from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import isNotDuplicateRule, parseRule, parseArtifact, parseResult


class Slither(Parser):

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        result_tar = os.path.join(self._task.result_output_path(), 'result.tar')
        try:
            with tarfile.open(result_tar, 'r') as tar:
                output_file = tar.extractfile('output.json')
                self._analysis = json.loads(output_file.read())
        except Exception as e:
            self._errors.add(f'problem accessing {result_tar} or output.json')
            return
        
    def parseSarif(self, slither_output_results, file_path_in_repo):
        rulesList = []
        resultsList = []

        for analysis in slither_output_results["analysis"]:

            level = analysis["impact"]
            message = analysis["description"]
            locations = []

            for element in analysis["elements"]:
                location = Location(physical_location=PhysicalLocation(
                    artifact_location=ArtifactLocation(uri=file_path_in_repo),
                    region=Region(start_line=element["source_mapping"]["lines"][0],
                                  end_line=element["source_mapping"]["lines"][-1])), logical_locations=[])

                if "name" in element.keys():
                    if "type" in element.keys():
                        location.logical_locations.append(LogicalLocation(
                            name=element["name"], kind=element["type"]))
                    if "target" in element.keys():
                        location.logical_locations.append(LogicalLocation(
                            name=element["name"], kind=element["target"]))
                if "expression" in element.keys():
                    location.physical_location.region.snippet = ArtifactContent(
                        text=element["expression"])
                if "contract" in element.keys():
                    location.logical_locations.append(
                        LogicalLocation(name=element["contract"]["name"], kind=element["contract"]["type"]))
                locations.append(location)

            result = parseResult(
                tool="slither", vulnerability=analysis["check"], level=level)

            result.locations = locations

            rule = parseRule(
                tool="slither", vulnerability=analysis["check"], full_description=message)

            if isNotDuplicateRule(rule, rulesList):
                rulesList.append(rule)

            resultsList.append(result)

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="Slither", version="0.7.0", rules=rulesList,
                                         information_uri="https://github.com/crytic/slither",
                                         full_description=MultiformatMessageString(
                                             text="Slither is a Solidity static analysis framework written in Python 3. It runs a suite of vulnerability detectors and prints visual information about contract details. Slither enables developers to find vulnerabilities, enhance their code comprehension, and quickly prototype custom analyses.")))

        run = Run(tool=tool, artifacts=[artifact], results=resultsList)

        return run


if __name__ == '__main__':
    import Parser
    Parser.main(Slither)

