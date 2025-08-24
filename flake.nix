{
  description = "Nix flake for pioneering seamless integration of nightly builds for the NixOS community.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    nix-fast-build.url = "github:Mic92/nix-fast-build";
    flake-compat.url = "github:edolstra/flake-compat";
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs: with inputs;
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = (import nixpkgs) { inherit system; config.allowUnfree = true; };
        inherit (nixpkgs) lib;
        inherit (import ./lib { inherit lib; }) sharedLib;
        # function to generate pre-commit-checks
        genChecks = system: (pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true; # formatter
            statix.enable = true; # linter
            deadnix.enable = true; # linter
          };
        });
        # function to generate package as output
        genPkgs = { packages, qtPackages }: (
          # (lib.attrsets.mergeAttrsList): merge attribute sets, expect input as a list
          lib.attrsets.mergeAttrsList (
            # (map): instantiate package from input list
            (map (package: { "${package}_nightly" = pkgs.callPackage ./pkgs/${package} { inherit sharedLib; }; }) packages) ++
            (map (package: { "${package}_nightly" = pkgs.qt6Packages.callPackage ./pkgs/${package} { inherit sharedLib; }; }) qtPackages)
          ));
      in
      {
        # checks
        checks.pre-commit-check = genChecks system;
        packages = { nix-fast-build = inputs.nix-fast-build.packages.${system}.default; } //
          genPkgs {
            packages = [
              "glider"
            ];
            qtPackages = [
              "qutebrowser"
            ];
          };
      });
}
