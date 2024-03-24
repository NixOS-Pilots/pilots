{ stdenv
, fetchFromGitHub
, sharedLib
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nvim";
  version = "unstable-2024-03-24-unwrapped";

  meta = with lib; {
    description = "Vim-fork focused on extensibility and usability";
    homepage = "https://neovim.io/";
    license = licenses.asl20;
    platforms = platforms.linux;
    mainProgram = pname;
    maintainers = with maintainers; [ kev ];
  };

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
