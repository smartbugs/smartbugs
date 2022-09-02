import argparse, csv, json, sys

def aggregate(csvfilenames, tools, runs):
    aggregated = {}
    parsers = {}
    for fn in csvfilenames:
        with open(fn) as csvfile:
            # contract,tool,exit_code,duration,findings,messages,errors,fails,dataset,
            # parser_name,parser_version,timeout,out_of_memory,other_fails,error,success
            for run in csv.DictReader(csvfile):
                tool = run["tool"]
                run_id = run["run"] if "run" in run else run["dataset"]
                if (tools and tool not in tools) or (runs and run_id not in runs):
                    continue
                contract = run["contract"].split('.')
                contract0 = contract[0]
                contract1 = contract[1] if len(contract)>1 else contract0
                if contract0 not in aggregated:
                    aggregated[contract0] = {}
                a = aggregated[contract0]
                if tool not in a:
                    a[tool]={}
                a = a[tool]
                if run_id not in a:
                    a[run_id] = {}
                a = a[run_id]
                if contract1 in a:
                    print(f"{run['contract']}/{tool}/{run_id} appears more than once, ignoring it")
                    continue
                a[contract1] = run
                if tool not in parsers:
                    parsers[tool] = { "names": set(), "versions": set() }
                parsers[tool]["names"].add(run["parser_name"])
                parsers[tool]["versions"].add(run["parser_version"])
    for tool,parser in parsers.items():
        if len(parser["names"]) > 1:
            print(f"Tool {tool}: multiple parsers in use: {parser['names']}")
        if  len(parser["names"]) == 1 and len(parser["versions"]) > 1:
            for p in parser["names"]:
                break
            print(f"Tool {tool}: multiple versions of parser {p} in use: {parser['versions']}")
    return aggregated


def report(aggregated, duration_delta, fields, verbose):
    singletons = []
    homogeneous = []
    inhomogeneous = []
    max_delta = 0
    for family,tool_run_code_data in aggregated.items():
        tools = set()
        runs = set()
        codes = []
        exit_codes = []
        durations = []
        findings = []
        errors = []
        messages = []
        fails = []
        for tool,run_code_data in tool_run_code_data.items():
            tools.add(tool)
            for run,code_data in run_code_data.items():
                runs.add(run)
                for code,data in code_data.items():
                    codes.append((tool,run,code))
                    exit_codes.append(data["exit_code"])
                    durations.append(float(data["duration"]))
                    findings.append(data["findings"])
                    errors.append(data["errors"])
                    messages.append(data["messages"])
                    fails.append(data["fails"])
        if len(codes) == 0:
            print(f"No codes for family {family}, tool(s) {tools}, run(s) {runs}!?")
            continue
        if len(codes) == 1:
            code = codes[0]
            singletons.append((family,code))
            continue
        duration_min = min(durations)
        duration_max = max(durations)
        delta = duration_max-duration_min
        max_delta = max(max_delta,delta)
        diff_durations = "duration" in fields and delta>duration_delta
        diff_exits = "exit_code" in fields and len(set(exit_codes)) > 1
        diff_findings = "findings" in fields and len(set(findings)) > 1
        diff_messages = "messages" in fields and len(set(messages)) > 1
        diff_errors = "errors" in fields and len(set(errors)) > 1
        diff_fails = "fails" in fields and len(set(fails)) > 1
        if not (diff_durations or diff_exits or diff_findings
                or diff_messages or diff_errors or diff_fails):
            homogeneous.append((family,codes))
            if not verbose:
                continue
        else:
            inhomogeneous.append((family,codes))
        print(f"\n{family}")
        sep='    '
        for tool,run,code in codes:
            print(sep, end='')
            sep = ', '
            if len(tools) > 1:
                print(f"{tool}/", end='')
            if len(runs) > 1:
                print(f"{run}/", end='')
            print(f"{code}", end='')
        print()
        if diff_durations or verbose:
            print(f"    duration: {durations} (delta {delta})")
        if diff_exits or verbose:
            print(f"    exit codes: {exit_codes}")
        if diff_findings or verbose:
            print(f"    findings: {findings}")
        if diff_messages or verbose:
            print(f"    messages: {messages}")
        if diff_errors or verbose:
            print(f"    errors: {errors}")
        if diff_fails or verbose:
            print(f"    fails: {fails}")

    hom_fam = len(homogeneous)
    hom_codes = sum([len(codes) for _,codes in homogeneous])
    inhom_fam = len(inhomogeneous)
    inhom_codes = sum([len(codes) for _,codes in inhomogeneous])
    inhom_fam_rel = inhom_fam*100.0/(inhom_fam+hom_fam)
    inhom_codes_rel = inhom_codes*100.0/(inhom_codes+hom_codes)

    print(f"\n{'='*20}\n")
    print(f"singletons:          {len(singletons)}")
    print(f"homogeneous:         {hom_fam} families ({hom_codes} codes)")
    print(f"inhomogeneous:       {inhom_fam} families, {round(inhom_fam_rel,1)}% ({inhom_codes} codes, {round(inhom_codes_rel,1)}%)")
    print(f"max. duration delta: {max_delta}")


def main():
    argparser = argparse.ArgumentParser(description="""
        Identify the differences in the results for multiple runs with the same skeleton.
        """)
    argparser.add_argument(
        "run_data",
        nargs='+',
        help="csv files with run data")
    argparser.add_argument(
        "-f", "--fields",
        nargs="*",
        metavar="FIELD",
        default=["exit_code","duration","findings","errors","fails"],
        choices=["exit_code","duration","findings","errors","fails","messages","all"],
        help="fields to compare the run data on")
    argparser.add_argument(
        "-s", "--spread",
        type=float,
        default=180.0,
        help="normal spread between run times (will not be reported)")
    argparser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="show also fields that are equal")
    argparser.add_argument(
        "-r", "--runs",
        nargs="+",
        metavar="RUN_ID",
        help="runs to consider")
    argparser.add_argument(
        "-t", "--tools",
        nargs="+",
        metavar='TOOL',
        help="tools to consider")
    args = argparser.parse_args()
    if "all" in args.fields:
        args.fields = ["exit_code","duration","findings","errors","fails","messages"]

    print("Arguments passed: ", vars(args))
    aggregated = aggregate(args.run_data, args.tools, args.runs)
    report(aggregated, args.spread, args.fields, args.verbose)


if __name__ == '__main__':
    sys.exit(main())

