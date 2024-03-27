{ stdenv
, writeShellScriptBin
, lib
, curl
, jq
, git
, nix
, nix-prefetch-git
}:
stdenv.mkDerivation
{
  pname = "git-upstream-updater";
  version = "0.1.0";

  # (writeShellScriptBin "git-upstream-updater" ''
  #     set -euo pipefail

  #     PATH=lib.makeBinPath [
  #     curl
  #     jq
  #     git
  #     nix-prefetch-git
  #     nix
  #   ];


  #     # Options
  #     _NIX_PREFETCH_ARGS=(--quiet)
  #     _NIX_PREFETCH_ARGS+=(--fetch-submodules)

  #     _LATEST_GIT=$(nix-prefetch-git "''${_NIX_PREFETCH_ARGS[@]}" --rev "$_LATEST_REV" "$_GIT_URL")

  #     _LATEST_HASH=$(echo $_LATEST_GIT | jq -r .hash)
  #     _LATEST_DATE=$(date -u --date=$(echo $_LATEST_GIT | jq -r .date) '+%Y-%m-%d')
  #     _LATEST_VERSION="unstable-''${_LATEST_DATE}-''${_LATEST_REV:0:7}"
  #     _LATEST_PATH=$(echo $_LATEST_GIT | jq -r .path)

  #     JQ_ARGS=(
  #       --arg version "$_LATEST_VERSION"
  #       --arg rev "$_LATEST_REV"
  #       --arg hash "$_LATEST_HASH"
  #     )

  #     JQ_OPS=(
  #       '.rev = $rev'
  #       '| .version = $version'
  #       '| .hash = $hash'
  #     )

  #     git add $_VERSION_JSON
  #     git commit -m "''${_NYX_KEY}: ''${_LOCAL_VER:9} -> ''${_LATEST_VERSION:9}"
  # '')

  meta = with lib; {
    homepage = "https://github.com/NixOS-Pilots/pilots";
    description = "Generic update-script to update metadata.json";
    license = licenses.mit;
    mainProgram = "git-upstream-updater";
    maintainers = with maintainers; [ kev ];
  };
}
