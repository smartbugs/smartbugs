#!/usr/bin/env python3

import os, argparse, multiprocessing
import sb.cfg, sb.io, sb.parsing, sb.sarif



def reparser(taskqueue, sarif, verbose):
    while True:
        d = taskqueue.get()
        if d is None:
            break

        fn_sbj = os.path.join(d, sb.cfg.TASK_LOG)
        fn_log = os.path.join(d, sb.cfg.TOOL_LOG)
        fn_tar = os.path.join(d, sb.cfg.TOOL_OUTPUT)
        fn_json = os.path.join(d, sb.cfg.PARSER_OUTPUT)
        fn_sarif = os.path.join(d, sb.cfg.SARIF_OUTPUT)

        if not os.path.exists(fn_sbj):
            if verbose:
                print(f"{d}: {sb.cfg.TASK_LOG} not found, skipping")
            continue

        for fn in (fn_json, fn_sarif):
            try:
                os.remove(fn)
            except:
                pass
        if os.path.exists(fn_json) or os.path.exists(fn_sarif):
            print(f"{d}: Cannot clear old parse output, skipping")
            continue

        if verbose:
            print(d)
        sbj = sb.io.read_json(fn_sbj)
        log = sb.io.read_lines(fn_log) if os.path.exists(fn_log) else None
        tar = sb.io.read_bin(fn_tar) if os.path.exists(fn_tar) else None
        parsed_result = sb.parsing.parse(sbj, log, tar)
        sb.io.write_json(fn_json, parsed_result)
        if sarif:
            sarif_result = sb.sarif.sarify(sbj["tool"], parsed_result["findings"])
            sb.io.write_json(fn_sarif, sarif_result)



def main():
    argparser = argparse.ArgumentParser(prog="python3 reparse.py",
        description=f"Parse the tool output ({sb.cfg.TOOL_LOG}, {sb.cfg.TOOL_OUTPUT}) into {sb.cfg.PARSER_OUTPUT}.")
    argparser.add_argument("--sarif",
        action="store_true",
        help=f"generate sarif output, {sb.cfg.SARIF_OUTPUT}, as well")
    argparser.add_argument("--processes",
        type=int,
        metavar="N",
        default=1,
        help="number of parallel processes (default 1)")
    argparser.add_argument("-v", "--verbose",
        action='store_true',
        help="show progress")
    argparser.add_argument("path_to_output",
        help="directory containing the tool output")
    args = argparser.parse_args()

    # spawn processes, instead of forking, to have same behavior under Linux and MacOS
    mp = multiprocessing.get_context("spawn")
    taskqueue = mp.Queue()

    reparsers = [ mp.Process(target=reparser, args=(taskqueue,args.sarif,args.verbose)) for _ in range(args.processes) ]
    for r in reparsers:
        r.start()

    for path,_,files in os.walk(args.path_to_output):
        if sb.cfg.TASK_LOG in files:
            taskqueue.put(path)
    for _ in range(args.processes):
        taskqueue.put(None)

    for r in reparsers:
        r.join()



if __name__ == '__main__':
    main()

