{ stdenv
, fetchFromGitHub
  # , sharedLib
}:

stdenv.mkDerivation (finalAttrs: {
  name = "neovim";
  src = ((import ../../lib/flake-compat.nix { }).legacyGetFlake
    # src = (sharedLib.legacyGetFlake
    {
      src = fetchFromGitHub
        {
          owner = finalAttrs.name;
          repo = finalAttrs.name;
          rev = "ed910604ca677c897f003d00832dc6a1cb3ac65d";
          hash = "sha256-+vfgzQFEPenQmhRl3aQ39KiU+92GVhO/4i05MyUQBOU=";
        } + "/contrib";
    }
  ).packages.x86_64-linux.neovim;

  installPhase = ''
    install -D $src/bin/${finalAttrs.name} $out/bin/${finalAttrs.name}
  '';
})
