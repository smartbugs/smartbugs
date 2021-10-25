import sys

class Logger():

    def __init__(self):
        self.file_path = None
        pass

    def __get_fd(self):
        if self.file_path is not None:
            return open(self.file_path, "w")
        return None

    def print(self, print_message: str, message: str = None):
        sys.stdout.write(print_message + "\n")
        fd = self.__get_fd()
        if fd is not None:
            if message is not None:
                fd.write(message + "\n")
            else:
                fd.write(print_message + "\n")


logs = Logger()
