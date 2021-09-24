from collections import namedtuple

import smartBugs
import unittest

"""
        WARNING!

    Test Module needs to be run from Repo Root.

    Run TestModule.py from {YourPath}/smartbugs/

    Example: python3 unittest/TestModule.py

"""

smartBugs.output_folder = 'unit_testing'

RunnableTask = namedtuple('RunnableTask', ['aggregate_sarif', 'dataset', 'file', 'import_path', 'info', 'list',
                                           'output_version', 'processes', 'skip_existing',
                                           'tool', 'unique_sarif_output'])

class TestSimpleDAO(unittest.TestCase):

    def test_honeybadger_on_simpleDAO(self):
        runnableTask = RunnableTask(False, None, ['dataset/reentrancy/simple_dao.sol'], 'FILE', None, None, 'all', 1,
                                    False, ['honeybadger'], True)
        smartBugs.exec_cmd(runnableTask)
        with open('results/unit_testing.sarif', 'r') as real_output:
            with open('unittest/expected/simple_dao/honeybadger.sarif', 'r') as expected_output:
                self.assertEqual(real_output.readlines(), expected_output.readlines())

    def test_maian_on_simpleDAO(self):
        runnableTask = RunnableTask(False, None, ['dataset/reentrancy/simple_dao.sol'], 'FILE', None, None, 'all', 1,
                                    False, ['maian'], True)
        smartBugs.exec_cmd(runnableTask)
        with open('results/unit_testing.sarif', 'r') as real_output:
            with open('unittest/expected/simple_dao/maian.sarif', 'r') as expected_output:
                self.assertEqual(real_output.readlines(), expected_output.readlines())

    def test_mythril_on_simpleDAO(self):
        runnableTask = RunnableTask(False, None, ['dataset/reentrancy/simple_dao.sol'], 'FILE', None, None, 'all', 1,
                                    False, ['mythril'], True)
        smartBugs.exec_cmd(runnableTask)
        with open('results/unit_testing.sarif', 'r') as real_output:
            with open('unittest/expected/simple_dao/mythril.sarif', 'r') as expected_output:
                self.assertEqual(real_output.readlines(), expected_output.readlines())

    def test_osiris_on_simpleDAO(self):
        runnableTask = RunnableTask(False, None, ['dataset/reentrancy/simple_dao.sol'], 'FILE', None, None, 'all', 1,
                                    False, ['osiris'], True)
        smartBugs.exec_cmd(runnableTask)
        with open('results/unit_testing.sarif', 'r') as real_output:
            with open('unittest/expected/simple_dao/osiris.sarif', 'r') as expected_output:
                self.assertEqual(real_output.readlines(), expected_output.readlines())

    def test_oyente_on_simpleDAO(self):
        runnableTask = RunnableTask(False, None, ['dataset/reentrancy/simple_dao.sol'], 'FILE', None, None, 'all', 1,
                                    False, ['oyente'], True)
        smartBugs.exec_cmd(runnableTask)
        with open('results/unit_testing.sarif', 'r') as real_output:
            with open('unittest/expected/simple_dao/oyente.sarif', 'r') as expected_output:
                self.assertEqual(real_output.readlines(), expected_output.readlines())

    def test_securify_on_simpleDAO(self):
        runnableTask = RunnableTask(False, None, ['dataset/reentrancy/simple_dao.sol'], 'FILE', None, None, 'all', 1,
                                    False, ['securify'], True)
        smartBugs.exec_cmd(runnableTask)
        with open('results/unit_testing.sarif', 'r') as real_output:
            with open('unittest/expected/simple_dao/securify.sarif', 'r') as expected_output:
                self.assertEqual(real_output.readlines(), expected_output.readlines())

    def test_slither_on_simpleDAO(self):
        runnableTask = RunnableTask(False, None, ['dataset/reentrancy/simple_dao.sol'], 'FILE', None, None, 'all', 1,
                                    False, ['slither'], True)
        smartBugs.exec_cmd(runnableTask)
        with open('results/unit_testing.sarif', 'r') as real_output:
            with open('unittest/expected/simple_dao/slither.sarif', 'r') as expected_output:
                self.assertEqual(real_output.readlines(), expected_output.readlines())

    def test_smartcheck_on_simpleDAO(self):
        runnableTask = RunnableTask(False, None, ['dataset/reentrancy/simple_dao.sol'], 'FILE', None, None, 'all', 1,
                                    False, ['smartcheck'], True)
        smartBugs.exec_cmd(runnableTask)
        with open('results/unit_testing.sarif', 'r') as real_output:
            with open('unittest/expected/simple_dao/smartcheck.sarif', 'r') as expected_output:
                self.assertEqual(real_output.readlines(), expected_output.readlines())

    def test_solhint_on_simpleDAO(self):
        runnableTask = RunnableTask(False, None, ['dataset/reentrancy/simple_dao.sol'], 'FILE', None, None, 'all', 1,
                                    False, ['solhint'], True)
        smartBugs.exec_cmd(runnableTask)
        with open('results/unit_testing.sarif', 'r') as real_output:
            with open('unittest/expected/simple_dao/solhint.sarif', 'r') as expected_output:
                self.assertEqual(real_output.readlines(), expected_output.readlines())

if __name__ == '__main__':
    unittest.main()
