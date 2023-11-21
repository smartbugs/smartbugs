with import <nixpkgs> {};
let
    reconstructCfg = import ./reconstructCfg.nix { inherit pkgs; };
    ethor = import ./precompiled-ethor.nix;
#    ethorWithReconstruction = import ./ethor-with-reconstruction.nix { inherit stdenv coreutils gnugrep findutils killall writeShellScriptBin reconstructCfg ethor; };
    envInUsrBin = stdenv.mkDerivation {
      name = "env-in-usr-lib";
      phases = [ "installPhase" ];
      installPhase = ''
            mkdir -p $out/usr/bin
            ln -s ${coreutils}/bin/env $out/usr/bin
      '';
    };
in
  dockerTools.buildImage {
    name = "ethor";
    extraCommands = "mkdir -m 0777 tmp";
    contents = buildEnv {
      name = "container_env";
      paths = [
        ethor
#        ethorWithReconstruction
#        reconstructCfg
        bashInteractive
        coreutils
        envInUsrBin
      ];
    };
    config = {
      Env = [];
      WorkingDir = "/mnt";
      Cmd = [ "/bin/bash" ];
    };
  }
