from manticore.ethereum import ManticoreEVM
import sys

m = ManticoreEVM()

with open(sys.argv[1], 'rb') as f:
    bytecode = f.read()

user_account = m.create_account(balance=10000000)

contract_account = m.create_contract(owner=user_account, init=bytecode)

symbolic_data = m.make_symbolic_buffer(320)
symbolic_value = m.make_symbolic_value()
m.transaction(
    caller=user_account, address=contract_account, data=symbolic_data, value=symbolic_value
)

# Let seth know we are not sending more transactions
m.finalize()
print(f"[+] Look for results in {m.workspace}")
