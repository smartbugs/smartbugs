import sys
from time import localtime, strftime

class Logger():

    def __init__(self):
        self.file_path = None
        pass

    def __get_fd(self):
        if self.file_path is not None:
            return open(self.file_path, "a")
        return None

    def print(self, print_message: str, message: str = None):
        sys.stdout.write(f"{print_message}\n")
        fd = self.__get_fd()
        if fd is not None:
            if message is not None:
                fd.write(f"[{strftime('%Y/%m/%d %H:%M:%S', localtime())}] {message}\n")
            else:
                fd.write(f"[{strftime('%Y/%m/%d %H:%M:%S', localtime())}] {print_message}\n")


logs = Logger()
