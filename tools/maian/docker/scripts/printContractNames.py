import sys

from solidity_parser import parser


source_unit = parser.parse_file(sys.argv[1])
# pprint.pprint(source_unit)

source_unit_object = parser.objectify(source_unit)

# access imports, contracts, functions, ...  (see outline example in
# __main__.py)
source_unit_object.imports  # []
source_unit_object.pragmas  # []
for contract_name in source_unit_object.contracts.keys():
    print(contract_name)
