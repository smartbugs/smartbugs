import multiprocessing, threading, os, sys, time, re
import sb.colors

def logger_process(logfn, overwrite, queue, prolog):
    log_parent_folder = os.path.dirname(logfn)
    if log_parent_folder:
        os.makedirs(log_parent_folder, exist_ok=True)
    mode = "w" if overwrite else "a"
    with open(logfn, mode) as logfile:
        for log in prolog:
            print(log, file=logfile)
        while True:
            log = queue.get()
            if log is None:
                break
            print(log, file=logfile)

__prolog = []

def start(logfn, append, queue):
    global logger
    logger = threading.Thread(target=logger_process, args=(logfn,append,queue,__prolog))
    logger.start()

quiet = False

def message(con=None, log=None, queue=None):
    if con and log=="":
        log = sb.colors.strip(con)
    if con and not quiet:
        print(con, flush=True)
    if log:
        if queue:
            queue.put(log)
        else:
            __prolog.append(log)

def stop(queue):
    queue.put(None)
    logger.join()

