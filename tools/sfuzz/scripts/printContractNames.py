import sys, json
from subprocess import PIPE, Popen

filename = sys.argv[1]
cmd = ["solc", "--standard-json", "--allow-paths", ".,/"]
settings = {
    "optimizer": {"enabled": False},
    "outputSelection": {
        "*": {
            "*": [ "evm.deployedBytecode" ],
        }
    },
}

input_json = json.dumps(
    {
        "language": "Solidity",
        "sources": {filename: {"urls": [filename]}},
        "settings": settings,
    }
)
p = Popen(cmd, stdin=PIPE, stdout=PIPE, stderr=PIPE)
stdout, stderr = p.communicate(bytes(input_json, "utf8"))
out = stdout.decode("UTF-8")
result = json.loads(out)
for error in result.get("errors", []):
    if error["severity"] == "error":
        print(error["formattedMessage"])
        sys.exit(1)
contracts = result["contracts"][filename]
for contract in contracts.keys():
    if len(contracts[contract]["evm"]["deployedBytecode"]["object"]):
        print(contract)
