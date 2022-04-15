import multiprocessing, threading, os, sys, time, re
import src.colors as col

queue = multiprocessing.Queue()

def logger_process(run_id, append):
    filename = os.path.join('results', 'logs', f'SmartBugs_{run_id}.log')
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with open(filename, "a" if append else "w") as logfile:
        while True:
            msg_stdout, msg_log = queue.get()
            if not msg_stdout and not msg_log:
                break
            if msg_stdout:
                print(msg_stdout, flush=True)
            if type(msg_log) == str:
                print(msg_log, file=logfile)
            elif msg_log:
                print(col.strip(msg_stdout), file=logfile)

def start(run_id, append=False):
    global logger
    logger = threading.Thread(
            target=logger_process,
            args=(run_id,append)
        )
    logger.start()

def message(msg_stdout, msg_log=True):
    queue.put_nowait((msg_stdout, msg_log))

def stop():
    queue.put_nowait((None,None))
    logger.join()
