import json,sys,os,traceback,re,csv,argparse

FIELDS = [ "contract", "tool", "exit_code", "duration", "findings", "messages", "errors", "fails", "dataset", "parser_name", "parser_version", "timeout", "out_of_memory", "other_fails", "error", "success" ]

def main():
    argparser = argparse.ArgumentParser(prog="python3 results2csv.py", description="""
        Write key information from result.json files to stdout, in csv format.
        """)
    argparser.add_argument("-n", action='store_true', help="read result.new.json instead of result.json.")
    argparser.add_argument("-p", "--postgres", action='store_true', help="encode lists as Postgres arrays")
    argparser.add_argument("-v", "--verbose", action='store_true', help="show progress")
    argparser.add_argument("path_to_results", help="directory containing the result files")
    argparser.add_argument("dataset", nargs='?', default=None, help="label identifying the dataset/run")
    args = argparser.parse_args()

    jsn_name = "result.new.json" if args.n else "result.json"

    csv_out = csv.writer(sys.stdout)
    csv_out.writerow(FIELDS)

    results = []
    for path,_,files in os.walk(args.path_to_results):
        if jsn_name in files:
            results.append(os.path.join(path,jsn_name))
    dataset = args.dataset
    for r in sorted(results):
        if args.verbose:
            print(r, file=sys.stderr)
        dataset = args.dataset if args.dataset else os.path.abspath(r).split(os.sep)[-3]
        result2csv(r, dataset, args.postgres, csv_out)

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

def data2csv(data, dataset, postgres):
    for f in ("findings", "messages", "errors", "fails"):
        if f not in data:
            data[f] = []
    csv = {
        "contract": os.path.basename(data["contract"]),
        "dataset": dataset
    }
    for f in ("tool", "duration", "exit_code"):
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
    return [ csv[f] for f in FIELDS ]

def result2csv(result_fn, dataset, postgres, csv_out):
    with open(result_fn) as f:
        data = json.load(f)
    csv_out.writerow(data2csv(data, dataset, postgres))

if __name__ == '__main__':
    sys.exit(main())
