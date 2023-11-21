{
  description = "Ethor and related tools";

  outputs = { self, nixpkgs }:
  let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {

    packages.x86_64-linux.hello =
      let
        reconstructCfg = import ./reconstructCfg.nix { inherit pkgs; };
        ethor = import ./precompiled-ethor.nix { inherit pkgs; };
        ethorWithReconstruction = import ./ethor-with-reconstruction.nix {
          inherit (pkgs) stdenv coreutils gnugrep findutils killall writeShellScriptBin;
          inherit reconstructCfg ethor;
        };
        envInUsrBin = pkgs.stdenv.mkDerivation {
          name = "env-in-usr-lib";
          phases = [ "installPhase" ];
          installPhase = ''
            mkdir -p $out/usr/bin
            ln -s ${pkgs.coreutils}/bin/env $out/usr/bin
          '';
        };
      in pkgs.dockerTools.buildImage {
        name = "ethor";
        extraCommands = "mkdir -m 0777 tmp";
        contents = pkgs.buildEnv {
          name = "container_env";
          paths = [
            ethor
            ethorWithReconstruction
            reconstructCfg
            pkgs.bashInteractive
            pkgs.coreutils
            envInUsrBin
          ];
        };
        config = {
          Env = [ ];
          WorkingDir = "/mnt";
          Cmd = [ "/bin/bash" ];
        };
      };

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;
    packages.x86_64-linux.ethor = import ./precompiled-ethor.nix { inherit pkgs; };
    packages.x86_64-linux.reconstructCfg = import ./reconstructCfg.nix { inherit pkgs; };
  };
}
