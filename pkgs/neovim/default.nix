{ stdenv
, fetchFromGitHub
, sharedLib
}:

stdenv.mkDerivation (finalAttrs: {
  name = "neovim";
  version = "unstable-2024-03-24-ed91060";
  src = (sharedLib.legacyGetFlake
    {
      src = fetchFromGitHub
        {
          owner = "nix-community";
          repo = "neovim-nightly-overlay";
          rev = "dc1d09c95137ce5b6889f4266ea7301d2af071f1";
          hash = "sha256-+RQ20E5N6bQcZtSuwIx+4ELFwbfMOZ7W7tgrU9vxdA8=";
        };
    }
  ).packages.x86_64-linux.neovim;

  installPhase = ''
    cp -r . $out/
  '';
})
