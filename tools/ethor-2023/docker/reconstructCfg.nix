{pkgs, ...}:
with pkgs;
let
  souffleThor = stdenv.mkDerivation rec {
    pname = "souffleThor";
    version = "0.1";
    src = fetchurl {
      url = "https://owncloud.tuwien.ac.at/index.php/s/ctL6MTorCuYsV5N/download";
      sha256 = "0ng16z4g6s8sfrmkczsg2j8gvklxq7xbxgyzx1d2xbi564zdnwrj";
    };

    buildInputs = with pkgs; [ unzip ];

    phases = ["unpackPhase" "patchPhase" "installPhase"];

    patches = [ ./reconstruction.patch ];

    patchFlags = [ "-p0" ];

    unpackPhase = ''
      unzip $src
    '';

    installPhase = ''
      mkdir $out
      mv * $out
    '';
  };
in
   stdenv.mkDerivation rec {
    pname = "reconstruct-cfg";
    version = "0.1";

    phases = [ "installPhase" ];

    buildInputs = with pkgs; [ openjdk8_headless souffle python3 makeWrapper ];

    runReconstruct = writeShellScriptBin "run-reconstruct" ''
      set -eu
      INPUT_DIR=$(${mktemp}/bin/mktemp -d)
      OUTPUT_DIR=$(${mktemp}/bin/mktemp -d)
      INPUT_FILE="$1"
      INPUT_NAME="$(${coreutils}/bin/basename "$INPUT_FILE" .txt)"
      OUTPUT_FILE="$2"

      ${coreutils}/bin/cp "$INPUT_FILE" "$INPUT_DIR/$INPUT_NAME.txt"

      ${souffleThor}/script/reconstruct.sh "$INPUT_DIR" "$OUTPUT_DIR"

      ${coreutils}/bin/cp "$OUTPUT_DIR/"* "$OUTPUT_FILE"

      ${coreutils}/bin/rm -r "$INPUT_DIR"
      ${coreutils}/bin/rm -r "$OUTPUT_DIR"
    '';

    installPhase = ''
      makeWrapper ${runReconstruct}/bin/run-reconstruct $out/bin/run-reconstruct \
        --prefix PATH : ${openjdk8_headless}/bin \
        --prefix PATH : ${souffle}/bin \
        --prefix PATH : ${python3}/bin
    '';
  }
