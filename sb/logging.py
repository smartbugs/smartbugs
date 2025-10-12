import os
import threading
from multiprocessing.queues import Queue
from typing import TYPE_CHECKING, Optional

import sb.colors


if TYPE_CHECKING:
    pass


def logger_process(
    logfn: str, overwrite: bool, queue: "Queue[Optional[str]]", prolog: list[str]
) -> None:
    log_parent_folder = os.path.dirname(logfn)
    if log_parent_folder:
        os.makedirs(log_parent_folder, exist_ok=True)
    mode = "w" if overwrite else "a"
    with open(logfn, mode) as logfile:
        for log in prolog:
            print(log, file=logfile)
        while True:
            log_item = queue.get()
            if log_item is None:
                break
            print(log_item, file=logfile)


__prolog: list[str] = []
logger: Optional[threading.Thread] = None


def start(logfn: str, append: bool, queue: "Queue[Optional[str]]") -> None:
    global logger
    logger = threading.Thread(target=logger_process, args=(logfn, append, queue, __prolog))
    logger.start()


quiet = False


def message(
    con: Optional[str] = None,
    log: Optional[str] = None,
    queue: Optional["Queue[Optional[str]]"] = None,
) -> None:
    if con and log == "":
        log = sb.colors.strip(con)
    if con and not quiet:
        print(con, flush=True)
    if log:
        if queue:
            queue.put(log)
        else:
            __prolog.append(log)


def stop(queue: "Queue[Optional[str]]") -> None:
    queue.put(None)
    if logger is not None:
        logger.join()
