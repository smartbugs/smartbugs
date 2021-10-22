import argparse

import os, sys
sys.path.insert(0, os.getcwd()) 
from src.output_parser.Oyente import Oyente


def create_parser():
    parser = argparse.ArgumentParser(description="To debug output parser")
    parser.add_argument('-f',
                        '--file',
                        required=True,
                        help='select the log file to prase')
    parser.add_argument('-t',
                        '--tool',
                        required=True,
                        help='select tool')
    args = parser.parse_args()
    return(args)


params = create_parser()

file_path = os.path.abspath(params.file)
with open(file_path) as fd:
    content = fd.read()
    parser = None
    if params.tool == "Oyente":
        parser = Oyente(content)

    print(parser.is_success())
    print(parser.parse())
