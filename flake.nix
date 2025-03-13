# From: https://dev.to/deciduously/workstation-management-with-nix-flakes-build-a-cmake-c-package-21lp
{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      pass-secrets = (with pkgs; stdenv.mkDerivation {
          pname = "pass-secrets";
          version = "0.0.1";
          src = fetchgit {
            url = "https://github.com/nullobsi/pass-secrets";
            rev = "72dde8b51c10728fc19c646700bb0b1c0ad8c366";
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
            cp $TMP/pass-secrets-72dde8b/build/pass-secrets $out/bin
          '';
        }
      );
    in rec {
      defaultApp = flake-utils.lib.mkApp {
        drv = defaultPackage;
      };
      defaultPackage = pass-secrets;
      devShell = pkgs.mkShell {
        buildInputs = [
          pass-secrets
        ];
      };
    }
  );
}
