{
  description = "P3oC development flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    dagger.url = "github:dagger/nix";
    dagger.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      dagger,
      ...
    }@inputs:
    with inputs.nixpkgs.lib;
    let

      # Define your overlay
      daggerOverlay = system: final: prev: {
        dagger = dagger.packages.${system}.dagger;
      };

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forEachSupportedSystem =
        f:
        genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ (daggerOverlay system) ];
            };
          }
        );

      mkDevShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = import ./shell.nix pkgs;
        }
      );
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      devShells = mkDevShells;
    };
}
