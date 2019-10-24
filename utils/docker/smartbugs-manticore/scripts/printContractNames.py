import sys
import pprint

from solidity_parser import parser

sourceUnit = parser.parse_file(sys.argv[1])
#pprint.pprint(sourceUnit)

sourceUnitObject = parser.objectify(sourceUnit)

# access imports, contracts, functions, ...  (see outline example in
# __main__.py)
sourceUnitObject.imports  # []
sourceUnitObject.pragmas  # []
for contract_name in sourceUnitObject.contracts.keys():
    print(contract_name)
