{ stdenv, lib, fetchFromGitHub, python, jdk }:

stdenv.mkDerivation rec {
  pname = "z3";
  version = "4.8.4-908-ga2b18a37e";

  src = fetchFromGitHub {
    owner  = "Z3Prover";
    repo   = pname;
    rev    = "z3-${version}";
    sha256 = "1wizp61ls43s71r3kp4jx9qyh2bbji8007w25qbfh6sr5jbv68ha";
  };

  buildInputs = [ python jdk ];
  enableParallelBuilding = true;

  configurePhase = ''
    ${python.interpreter} scripts/mk_make.py --prefix=$out --java
    cd build
  '';

  postInstall = ''
    mkdir -p $dev $lib $java
    mv $out/lib          $lib/lib
    mv $out/include      $dev/include
  '';

  outputs = [ "out" "lib" "dev" ];

  meta = {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "https://github.com/Z3Prover/z3";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.x86_64;
  };
}
