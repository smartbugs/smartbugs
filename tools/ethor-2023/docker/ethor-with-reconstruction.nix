{ stdenv, coreutils, gnugrep, findutils, killall, writeShellScriptBin, reconstructCfg, ethor }:

stdenv.mkDerivation rec {
  version = "0.2";
  pname = "ethor-with-reconstruction-${version}";

  phases = [ "installPhase" ];

  runQuery = writeShellScriptBin "run-query" ''
    set -u
    OUTDIR="$(${coreutils}/bin/mktemp -d)"
    OUT="$OUTDIR/out"
    ERR="$OUTDIR/err"
    FILE=$1

    Z3_TIMEOUT=''${Z3_TIMEOUT:-0}
    EARLY_EXIT_ON_SAT=''${EARLY_EXIT_ON_SAT:-NO}
    
    timeout "$Z3_TIMEOUT" ${ethor.z3}/bin/z3 "$FILE" > "$OUT" 2> "$ERR"
    RES=$?
    [ $RES != "0" ]  && echo "unknown (exitcode $RES)" >> "$OUT"
    
    echo "$OUTDIR"
    
    if [ $EARLY_EXIT_ON_SAT = "YES" ]; then
      if ${gnugrep}/bin/grep -oE '^sat$' "$OUT" > /dev/null; then
        ${killall}/bin/killall z3
      fi
    fi
    '';

  ethorWithReconstruction = writeShellScriptBin "ethor-with-reconstruction" ''
    set -eu
    HEX_FILE=$1
    WORK_DIR="$(${coreutils}/bin/mktemp -d)"
    JSON_FILE="$WORK_DIR/$(${coreutils}/bin/basename $HEX_FILE).json"
    RESULT_FILE="$WORK_DIR/result"

    ${reconstructCfg}/bin/run-reconstruct "$HEX_FILE" "$JSON_FILE" > /dev/null
    shift
    ${ethor}/bin/ethor $* --no-output-query-results --smt-out-dir "$WORK_DIR" -- "$JSON_FILE"

    SMT_FILE="$JSON_FILE.smt"

    if [ ! -f "$SMT_FILE" ]; then
      echo "$HEX_FILE unknown" 
      exit 0
    fi

    ID="$(${coreutils}/bin/basename \\"$SMT_FILE\\" .json.smt)"
    SPLITS="$WORK_DIR/splits/"

    ${coreutils}/bin/mkdir -p "$SPLITS"

    ${gnugrep}/bin/grep '(query' "$SMT_FILE" | ${gnugrep}/bin/grep -oE 'reentrancy[^)]*' |
    ${findutils}/bin/xargs -I{} sh -c "${gnugrep}/bin/grep -v '(query' $SMT_FILE > $SPLITS/$ID-{}.smt; ${gnugrep}/bin/grep '(query {}' $SMT_FILE >> $SPLITS/$ID-{}.smt"

    ${findutils}/bin/find "$SPLITS" -type f |
    ${findutils}/bin/xargs -P0 -L1 ${runQuery}/bin/run-query 2> /dev/null |
    ${findutils}/bin/xargs -I{} sh -c '${coreutils}/bin/cat "{}/out"; ${coreutils}/bin/rm -r "{}"' > "$RESULT_FILE"

    if ${gnugrep}/bin/grep -oE '^sat$' "$RESULT_FILE" > /dev/null; then
      echo "$HEX_FILE insecure" 
    elif ${gnugrep}/bin/grep -oE '^unknown' "$RESULT_FILE" > /dev/null; then
      echo "$HEX_FILE unknown" 
    else
      echo "$HEX_FILE secure"
    fi

    ${coreutils}/bin/rm -r "$WORK_DIR"
  '';

  installPhase = ''
      cp -r ${ethorWithReconstruction} $out
  '';
}

