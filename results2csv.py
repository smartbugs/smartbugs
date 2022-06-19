import json,sys,os,traceback,re,csv,argparse

HEADERS = [ 'contract','tool','exit_code','duration','success','findings','errors','run' ]

def main():
    argparser = argparse.ArgumentParser(prog="python3 results2csv.py", description="""
        Write key information from result.json files to stdout, in csv format.
        """)
    argparser.add_argument("-n", action='store_true', help="read result.new.json instead of result.json.")
    argparser.add_argument("path_to_results", help="directory containing the result files")
    argparser.add_argument("run_id", help="label identifying the run that generated the results")
    args = argparser.parse_args()

    log_name = "result.new.json" if args.n else "result.json"
    path_to_results = args.path_to_results
    run_id = args.run_id

    csv_out = csv.writer(sys.stdout)
    csv_out.writerow(HEADERS)

    results = []
    for path,_,files in os.walk(path_to_results):
        if log_name in files:
            results.append(os.path.join(path,log_name))
    for r in sorted(results):
        result2csv(csv_out, run_id, r)


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


def result2csv(csv_out, run, result):
    with open(result) as f:
        try:
            data = json.load(f)
        except Exception:
            print(result)
            traceback.print_exc(file=sys.stdout)
            sys.stdout.flush()
            return 1
    if 'findings' not in data:
        data['findings'] = []
    if 'errors' not in data:
        data['errors'] = []
    data['success']  = not data['errors'] and data['exit_code'] == 0
    data['run'] = run
    data['contract'] = os.path.basename(data['contract'])
    data['findings'] = list2pgarray(data['findings'])
    data['errors']   = list2pgarray(data['errors'])
    csv_out.writerow([ data[k] for k in HEADERS ])

if __name__ == '__main__':
    sys.exit(main())
