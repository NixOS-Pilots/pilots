{ pkgs, lib, ... }:

with pkgs;
let
  pname = "glider";
  version = "unstable-2024-01-29-6d2b1e9";
  meta = with lib; {
    homepage = "https://github.com/nadoo/glider";
    description = "Forward proxy with multiple protocols support";
    license = licenses.gpl3Only;
    mainProgram = "glider";
    maintainers = with maintainers; [ kev ];
  };
in
buildGoModule {
  inherit pname version meta;

  src = fetchFromGitHub {
    owner = "nadoo";
    repo = "glider";
    rev = "6d2b1e95cc3a8ac7df2d47de5b719dde3cdb5f34";
    hash = "sha256-HdRio7V/V6BUMp26OPFIlb8v1TKsQZZwt2zPmUh0Ms8=";
  };

  vendorHash = "sha256-88lkFqpSx8YyZbMY2DWxIYt0EaRPu02RcvkWJtjxuPc=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    substituteInPlace systemd/glider@.service \
      --replace "/usr/bin/glider" "$out/bin/glider"
    install -Dm444 -t "$out/lib/systemd/system/" systemd/glider@.service
  '';
}
