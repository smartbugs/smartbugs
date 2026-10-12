#!/bin/sh
# SmartBugs entrypoint for GPTScan (solidity mode).
# Args (from config.yaml): FILENAME TIMEOUT BIN MAIN
FILENAME="$1"
TIMEOUT="$2"
BIN="$3"
MAIN="$4"

# Make the solc binary SmartBugs dropped into $BIN available to GPTScan/falcon.
export PATH="$BIN:$PATH"
chmod +x "$BIN/solc" 2>/dev/null || true

# MAIN=1: analyse only the contract the file is named after. GPTScan has no
# contract selection -- src/tasks.py::simple_cli takes a source *directory* and
# reports on everything that compiles in it -- so the restriction has to happen
# on the input. main_contract.py reduces the source to that contract and the
# definitions it needs, verifies with solc that the result still compiles, and
# restores the full source if it does not. Exit 127 means the file name matched
# no contract; SmartBugs reserves that code for exactly this case.
# MAIN=0 leaves SOURCE at the file SmartBugs passed in, byte for byte.
SOURCE="$FILENAME"
if [ "$MAIN" = "1" ]; then
    MAINDIR="${TMPDIR:-/tmp}/sb_main"
    rm -rf "$MAINDIR"
    mkdir -p "$MAINDIR"
    # Keep the original basename: GPTScan reports the file it analysed.
    REDUCED="$MAINDIR/$(basename "$FILENAME")"
    python3 "$BIN/main_contract.py" --verify-compile "$FILENAME" "$REDUCED"
    RC=$?
    if [ $RC -ne 0 ]; then
        exit $RC
    fi
    SOURCE="$REDUCED"
fi

# --- Timeout budget ---------------------------------------------------------
# Three marks out of the one TIMEOUT SmartBugs hands us:
#   70%  brake -- exported as an absolute deadline; GPTScan stops issuing LLM
#         calls and runs out on its own, writing what it confirmed so far
#   90%  net   -- 'timeout' stops the tool if the brake did not take effect
#   rest       -- belongs to this script, to salvage and write /output.json
# TIMEOUT=0 (no --timeout) leaves every one of them unset: the run then behaves
# the same as it did before the timeout handling existed. (Not
# literally byte-for-byte: tasks.py always writes llm_calls_skipped_deadline
# and deadline_exceeded into GPTSCAN_META, timeout budget or not.)
NET=0
if [ "${TIMEOUT:-0}" -gt 0 ]; then
    BRAKE=$(( TIMEOUT * 7 / 10 ))
    NET=$(( TIMEOUT * 9 / 10 ))
    [ "$BRAKE" -lt 1 ] && BRAKE=1
    [ "$NET" -lt 1 ] && NET=1
    SB_DEADLINE_EPOCH=$(( $(date +%s) + BRAKE ))
    export SB_DEADLINE_EPOCH
    echo "SB_TIMEOUT_BUDGET timeout=${TIMEOUT}s brake=${BRAKE}s net=${NET}s"
fi

# GPTScan expects a *folder* containing a single .sol file, and silently
# produces empty output if the path contains certain keywords
# (external/openzeppelin/uniswap/pancakeswap/legacy/test). /work/input is safe.
WORK=/work/input
rm -rf "$WORK"
mkdir -p "$WORK"
cp "$SOURCE" "$WORK/"

# Backend selection: provider/model come from the (host-forwarded) environment,
# defaulting to deepseek / the provider's cheap tier. The API key arrives via
# DEEPSEEK_API_KEY / OPENAI_API_KEY, forwarded by SmartBugs according to the
# "env:" list in config.yaml.
PROVIDER="${GPTSCAN_PROVIDER:-deepseek}"
MODEL_OPT=""
if [ -n "$GPTSCAN_MODEL" ]; then
    MODEL_OPT="--model $GPTSCAN_MODEL"
fi
DRY_OPT=""
if [ "${GPTSCAN_DRY_RUN:-0}" = "1" ]; then
    DRY_OPT="--dry-run"
fi

cd /opt/gptscan/src || exit 1
echo "GPTScan: provider=$PROVIDER model=${GPTSCAN_MODEL:-<default>} dry_run=${GPTSCAN_DRY_RUN:-0}"
if [ "$NET" -gt 0 ]; then
    timeout -s TERM "$NET" python3 main.py -s "$WORK" -o /output.json \
        --provider "$PROVIDER" $MODEL_OPT $DRY_OPT --format json
else
    python3 main.py -s "$WORK" -o /output.json \
        --provider "$PROVIDER" $MODEL_OPT $DRY_OPT --format json
fi
RC=$?

# 'timeout' reports 124 (GNU) or 143 (BusyBox); 137 appears when a SIGTERM was
# escalated to SIGKILL. All three mean "we stopped it on purpose", but SmartBugs
# reads 143 and 137 as DOCKER_RECEIVED_SIGNAL_n and files them under *fails*
# (sb/parse_utils.py) --- the category for a tool that was knocked out.
# A deliberate timeout is not that, so the code is normalised to 124, which
# lands in *errors*: noticed and handled.
TIMED_OUT=0
if [ "$NET" -gt 0 ]; then
    case "$RC" in
        124|137|143) TIMED_OUT=1; RC=124 ;;
    esac
fi

# Surface the run metadata (tokens / cost / llm_calls) on a single line so the
# SmartBugs parser can record it without a second output file.
if [ -f /output.json.metadata.json ]; then
    echo "GPTSCAN_META $(tr -d '\r\n' < /output.json.metadata.json)"
fi

# Make sure the expected output file exists even when GPTScan found nothing /
# failed early, so SmartBugs can always retrieve it.
if [ ! -f /output.json ]; then
    echo '{"version":"1.1.0","success":false,"message":"no output produced","results":[]}' > /output.json
fi

# The brake writes its own marker (GPTScan does it in tasks.py); only the net
# needs a stamp from outside, because the tool never learned it was stopped.
if [ "$TIMED_OUT" = "1" ]; then
    python3 "$BIN/mark_timeout.py" /output.json net \
        "GPTScan stopped hard after ${NET}s; the brake at ${BRAKE}s did not take effect" \
        || echo "GPTScan: could not stamp the timeout marker"
fi

exit $RC
