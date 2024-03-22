{
  description = "Nix flake for bleeding-edge and unreleased open-source packages.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    in
    (flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = (import nixpkgs) { inherit system; config.allowUnfree = true; };
      in
      {
        packages = { };
      }));
}
