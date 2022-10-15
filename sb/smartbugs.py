import glob, os, operator
import sb.tools, sb.solidity, sb.tasks, sb.docker, sb.analysis, sb.colors, sb.logging, sb.config, sb.io



def collect_files(patterns):
    files = []
    for root,spec in patterns:
        if spec.endswith(".txt"):
            # No globbing, spec is a file specifying a 'dataset'
            contracts = sb.io.read_lines(spec)
        else:
            # avoid root_dir=... for python < 3.10 if not needed
            if not root:
                contracts = glob.glob(spec, recursive=True)
            else:
                contracts = glob.glob(spec, root_dir=root, recursive=True)
        for relfn in contracts:
            root_relfn = os.path.join(root,relfn) if root else relfn
            absfn = os.path.normpath(os.path.abspath(root_relfn))
            if os.path.isfile(absfn) and absfn[-4:] in (".hex", ".sol"):
                files.append( (absfn,relfn) )
    return files



def collect_tasks(files, tools, settings):
    rdirs = set()
    rdir_collisions = 0

    def disambiguate(base):
        nonlocal rdir_collisions
        cnt = 1
        rdir = base
        collision = 0
        while rdir in rdirs:
            collision = 1
            cnt += 1
            rdir = f"{base}_{cnt}"
        rdirs.add(rdir)
        rdir_collisions += collision
        return rdir

    tasks = []

    last_absfn = None
    for absfn,relfn in sorted(files):
        if absfn == last_absfn:
            # ignore duplicate contracts
            continue
        last_absfn = absfn

        is_hex = absfn[-4:]==".hex"
        is_sol = absfn[-4:]==".sol"
        solc_version = None
        if is_sol:
            prg = sb.io.read_lines(absfn)
            solc_version = sb.solidity.get_solc_version(prg)

        for tool in sorted(tools, key=operator.attrgetter("id", "mode")):
            if ((is_sol and tool.mode=="solidity") or
                (is_hex and tool.mode=="bytecode" and not settings.runtime) or
                (is_hex and tool.mode=="runtime"  and     settings.runtime)):
                base = settings.resultdir(tool.id,tool.mode,absfn,relfn)
                rdir = disambiguate(base)
                # due to sorting files and tools, rdir ought to be the same
                # when rerunning SB with the same args 
                solc_path = None
                if tool.solc:
                    solc_path = sb.solidity.get_solc_path(solc_version)
                if not sb.docker.is_loaded(tool.image):
                    sb.logging.message(f"Loading docker image {tool.image}, may take a while ...")
                    sb.docker.load(tool.image)
                task = sb.tasks.Task(absfn,relfn,rdir,solc_version,solc_path,tool,settings)
                tasks.append(task)

    if rdir_collisions > 0:
        sb.logging.message(
            sb.colors.warning(f"{rdir_collisions} collisions of result directories resolved."),
            "")
        if rdir_collisions > len(files)*0.1:
            sb.logging.message(
                "Consider using one or more of $TOOL, $MODE, $ABSDIR, $RELDIR, $FILENAME, $FILEBASE, $FILEEXT when specifying 'results' directory.")

    return tasks



def main(settings):
    settings.freeze()
    sb.logging.quiet = settings.quiet
    sb.logging.message(
        sb.colors.success(f"Welcome to SmartBugs {sb.config.VERSION}!"),
        f"Settings: {settings}")
    tools = sb.tools.load(settings.tools)
    files = collect_files(settings.files)
    tasks = collect_tasks(files, tools, settings)
    sb.analysis.run(tasks, settings)
