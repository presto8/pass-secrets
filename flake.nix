{
  description = "A simple flake to build pass-secrets and allow it to be added to a NixOS configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11-small";

  outputs =
    {
      self,
      nixpkgs,
      nix,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forEachSystem = nixpkgs.lib.genAttrs systems;

      overlayList = [ self.overlays.default ];

      pkgsBySystem = forEachSystem (
        system:
        import nixpkgs {
          inherit system;
          overlays = overlayList;
        }
      );

    in
    rec {

      overlays.default = final: prev: { pass-secrets = final.callPackage ./package.nix { }; };

      packages = forEachSystem (system: {
        pass-secrets = pkgsBySystem.${system}.pass-secrets;
        default = pkgsBySystem.${system}.pass-secrets;
      });

      nixosModules = import ./nixos-modules { overlays = overlayList; };

    };
}
