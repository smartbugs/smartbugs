class SmartBugsException(Exception):
    """
        Exception raised when SmartBugs throws an Exception.

        Attributes:
            Message -> The Exception message.
    """

    def __init__(self, message):
        self.message = message
        super().__init__(self.message)
