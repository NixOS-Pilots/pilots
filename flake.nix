{
  description = "Nix flake for pioneering seamless integration of nightly builds for the NixOS community.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    nix-fast-build.url = "github:Mic92/nix-fast-build";
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs: with inputs;
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = (import nixpkgs) { inherit system; config.allowUnfree = true; };
        genChecks = system: (pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true; # formatter
            statix.enable = true; # linter
            deadnix.enable = true; # linter
          };
        });
      in
      {
        # checks
        checks.pre-commit-check = genChecks system;
        packages = {
          nix-fast-build = inputs.nix-fast-build.packages.${system}.default;
          glider = pkgs.callPackage ./pkgs/glider { };
        };
      });
}
