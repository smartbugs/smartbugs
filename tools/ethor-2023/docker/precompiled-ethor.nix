{pkgs, ...}:
let
  version = "0.2";
in
  with pkgs; stdenv.mkDerivation rec {
  name = "ethor-${version}";
  z3 = import ./z3.nix { inherit stdenv lib fetchFromGitHub python jdk; };

  src = fetchurl {
    url = "https://owncloud.tuwien.ac.at/index.php/s/aQZhNxkCutDqHTl/download";
    sha256 = "0fg9j8yjjbp9c4ygb9w5lq4qjs754i9gaa3mxya5fhc138y5fp20";
  };

  jdk = pkgs.openjdk8_headless;

  phases = [ "installPhase" ];
  buildInputs = [ jdk z3 pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin/
    mkdir -p $out/lib/

    cp ${src} $out/lib/ethor.jar

    echo ${jdk}/bin/java -Xmx16G -jar $out/lib/ethor.jar '"$@"' > $out/bin/ethor
    chmod +x $out/bin/ethor

    wrapProgram $out/bin/ethor --prefix LD_LIBRARY_PATH : ${z3.lib}/lib/
  '';

  meta = with lib; {
    description = "A static analyzer using Horn clauses.";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };
}
