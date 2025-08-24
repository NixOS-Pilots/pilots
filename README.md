<h1 align="center">❄️ pilots</h1>
<p align="center">
    <em>Nix Flake for nightly softwares</em>
</p>
<p align="center">
  <img src="https://custom-icon-badges.herokuapp.com/github/license/NixOS-Pilots/pilots?style=flat&logo=law&colorA=24273A&color=blue" alt="License"/>
  <img src="https://img.shields.io/badge/NixOS-unstable-informational.svg?style=flat&logo=nixos&logoColor=CAD3F5&colorA=24273A&colorB=8AADF4">
  <img src="https://custom-icon-badges.herokuapp.com/github/last-commit/NixOS-Pilots/pilots?style=flat&logo=history&colorA=24273A&colorB=C4EEF2" alt="lastcommit"/>
</p>

## Our mission

Pioneering seamless integration of nightly builds for the NixOS community, fostering innovation and collaboration without compromising system stability.

## Social groups

Telegram groups

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

## Binary cache

If you like to fetch derivations from our cache where the build artefacts are pushed, it is available in [daeuniverse.cachix.org](https://app.cachix.org/cache/nixospilots#pull).

To enable it in your system, add the following to your `configuration.nix`:

```nix
{
  nix = {
    binaryCaches = [
      "https://nixospilots.cachix.org"
    ];
    binaryCachePublicKeys = [
      "nixospilots.cachix.org-1:agmYn3jPCVyiqhSfyPtW8vjB4WavuEdSv49skpup2XE="
    ];
  };
}
```

> [!WARNING]
> If you want to fetch derivations from our cache, you'll need to _**enable the binary cache**_ and _**rebuild your system**_ before adding these derivations to your configuration.
> Commands like `nix run`, `nix develop`, and others, when using our flake as input, will ask you to add the cache interactively when missing from your user's nix settings.
> If you want to use the cache right from the installation media, install your system using the following:

```bash
# replace host with your hostname
nixos-install --flake /mnt/etc/nixos#host --option 'extra-substituters' 'https://nixospilots.cachix.org/' --option extra-trusted-public-keys "nixospilots.cachix.org-1:agmYn3jPCVyiqhSfyPtW8vjB4WavuEdSv49skpup2XE="`
```

## Lists of options and packages

Coming soon

## License

[@NixOS-Pilots/pilots](https://github.com/NixOS-Pilots) is licensed under the [MIT License](./LICENSE).

Note: MIT license does not apply to the packages built by @Nixpkgs-Pilots/pilots, merely to the files in this repository (the Nix expressions, build scripts, NixOS modules, etc.). It also might not apply to patches included in @Nixpkgs-Pilots/pilots, which may be derivative works of the packages to which they apply. The aforementioned artifacts are all covered by the licenses of the respective packages.
