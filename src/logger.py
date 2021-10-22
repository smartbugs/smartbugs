class Logger():

    def __init__(self):
        self.file_path = None
        pass

    def __get_fd(self):
        if self.file_path is not None:
            return open(self.file_path, "w")
        return None

    def write(self, message: str):
        fd = self.__get_fd()
        if fd is not None:
            fd.write(message)


logs = Logger()
