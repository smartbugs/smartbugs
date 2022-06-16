if __name__ == '__main__':
    import sys
    sys.path.append("../..")


import src.output_parser.Gigahorse as Gigahorse

class Ethainter(Gigahorse.Gigahorse):

    def parseSarif(self, output_results, file_path_in_repo):
        pass


if __name__ == '__main__':
    import Parser
    Parser.main(Ethainter)
