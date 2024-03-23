<h1 align="center">❄️ pilots</h1>
<p align="center">
    <em>Nix Flake for nightly softwares</em>
</p>
<p align="center">
  <img src="https://custom-icon-badges.herokuapp.com/github/license/yqlbu/nixos-config?style=flat&logo=law&colorA=24273A&color=blue" alt="License"/>
  <img src="https://img.shields.io/static/v1?label=Nix Flake&message=check&style=flat&logo=nixos&colorA=24273A&colorB=9173ff&logoColor=CAD3F5">
  <img src="https://img.shields.io/badge/NixOS-unstable-informational.svg?style=flat&logo=nixos&logoColor=CAD3F5&colorA=24273A&colorB=8AADF4">
  <img src="https://custom-icon-badges.herokuapp.com/github/last-commit/yqlbu/nixos-config?style=flat&logo=history&colorA=24273A&colorB=C4EEF2" alt="lastcommit"/>
</p>

## Our mission

Pioneering seamless integration of nightly builds for the NixOS community, fostering innovation and collaboration without compromising system stability.

## Social groups

Telegram group chats:

- [NixOS-Pilots Chats](https://t.me/nixos_pilots)
- [NixOS-Pilots News](https://t.me/nixos_pilots_news)

## How to use

Integrate with Flake

```nix
{
  description = "My Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pilots.url = "github:NixOS-Pilots/pilots";
  };

  outputs = { nixpkgs, pilots, ... }: {
    nixosConfigurations = {
      hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix # Your system configuration.
          pilots.nixosModules.default # Our default module.
        ];
      };
    };
  };
}
```

## Binary Cache notes

Coming soon

## Lists of options and packages

Coming soon

## License

@NixOS-Pilots/pilots is licensed under the MIT License.

Note: MIT license does not apply to the packages built by @Nixpkgs-Pilots/pilots, merely to the files in this repository (the Nix expressions, build scripts, NixOS modules, etc.). It also might not apply to patches included in @Nixpkgs-Pilots/pilots, which may be derivative works of the packages to which they apply. The aforementioned artifacts are all covered by the licenses of the respective packages.
