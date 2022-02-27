if __name__ == '__main__':
    import sys
    sys.path.append("../..")


from src.output_parser.Gigahorse import Gigahorse

class Ethainter(Gigahorse):

    def parseSarif(self, output_results, file_path_in_repo):
        pass


if __name__ == '__main__':
    import Parser
    Parser.main(Ethainter)
