{ stdenv }:

let
  commit = "72dde8b51c10728fc19c646700bb0b1c0ad8c366";
in
stdenv.mkDerivation rec {
  pname = "pass-secrets";
  version = "2024-06-08";
  src = fetchgit {
    url = "https://github.com/nullobsi/pass-secrets";
    rev = commit;
    sha256 = "sha256-QP4vBNaFsLCL45Mog1A9438rCqnWgnWmRgVuL35S+4U=";
  };
  nativeBuildInputs = [
    clang
    cmake
    sdbus-cpp
  ];
  buildPhase = "make -j $NIX_BUILD_CORES";
  installPhase = ''
    mkdir -p $out/bin
    cp $TMP/pass-secrets-${builtins.substring 0 7 commit}/build/pass-secrets $out/bin
  '';
}
