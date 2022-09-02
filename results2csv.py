import json,sys,os,traceback,re,csv,argparse

FIELDS = (
    "contract", "tool", "run", "start", "duration", "exit_code",
    "findings", "messages", "errors", "fails",
    "parser_name", "parser_version",
    "timeout", "out_of_memory", "other_fails", "error", "success", "hit"
)

INSIGNIFICANT_FINDINGS = (
    ("maian", "Accepts_Ether"),
    ("maian", "No_Ether_leak_no_send"),
    ("maian", "No_Ether_lock_Ether_refused"),
    ("maian", "Not_destructible_no_self_destruct")
)

def main():
    argparser = argparse.ArgumentParser(prog="python3 results2csv.py", description="""
        Write key information from result.json files to stdout, in csv format.
        """)
    argparser.add_argument("-n", action='store_true', help="read result.new.json instead of result.json.")
    argparser.add_argument("-p", "--postgres", action='store_true', help="encode lists as Postgres arrays")
    argparser.add_argument("-v", "--verbose", action='store_true', help="show progress")
    argparser.add_argument("path_to_results", help="directory containing the result files")
    argparser.add_argument("run", nargs='?', default=None, help="label identifying the run/dataset")
    args = argparser.parse_args()

    jsn_name = "result.new.json" if args.n else "result.json"

    csv_out = csv.writer(sys.stdout)
    csv_out.writerow(FIELDS)

    results = []
    for path,_,files in os.walk(args.path_to_results):
        if jsn_name in files:
            results.append(os.path.join(path,jsn_name))
    run = args.run
    for r in sorted(results):
        if args.verbose:
            print(r, file=sys.stderr)
        run = args.run if args.run else os.path.abspath(r).split(os.sep)[-3]
        result2csv(r, run, args.postgres, csv_out)

def list2pgarray(l):
    a = '{'
    sep = ''
    for e in l:
        a += f'{sep}"'
        a += e.replace('"', r'\"')
        a += '"'
        sep = ', '
    a += '}'
    return a

def data2csv(data, run, postgres):
    for f in ("findings", "messages", "errors", "fails"):
        if f not in data:
            data[f] = []
    csv = {
        "contract": os.path.basename(data["contract"]),
        "run": run
    }
    for f in ("tool", "duration", "start", "exit_code"):
        csv[f] = data[f]
    for f in ("findings", "messages", "errors", "fails"):
        csv[f] = list2pgarray(data[f]) if postgres else ','.join(data[f])
    if "parser" in data:
        csv["parser_name"] = data["parser"]["name"]
        csv["parser_version"] = data["parser"]["version"]
    else:
        csv["parser_name"] = ""
        csv["parser_version"] = ""
    for f in ("timeout","out_of_memory","other_fails","error","success"):
        csv[f] = False
    if "DOCKER_TIMEOUT" in data["fails"]:
        csv["timeout"] = True
    elif "DOCKER_KILL_OOM" in data["fails"]:
        csv["out_of_memory"] = True
    elif data["fails"]:
        csv["other_fails"] = True
    elif data["errors"]:
        csv["error"] = True
    else:
        csv["success"] = True
    csv["hit"] = False
    t = data["tool"]
    for f in data["findings"]:
        if (t,f) in INSIGNIFICANT_FINDINGS:
            continue
        csv["hit"] = True
        break
    return [ csv[f] for f in FIELDS ]


def result2csv(result_fn, run, postgres, csv_out):
    with open(result_fn) as f:
        data = json.load(f)
    csv_out.writerow(data2csv(data, run, postgres))

if __name__ == '__main__':
    sys.exit(main())
