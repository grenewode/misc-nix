{ buildGoModule
, fetchFromGitHub
, fetchgit
, pkg-config
, libsecret
, which
, qt5
, git
, bintools
, lib
}:
buildGoModule rec {
  pname = "proton-bridge";
  version = "1.8.7";

  nativeBuildInputs = [ pkg-config which ];
  buildInputs = [ libsecret ];

  src = fetchFromGitHub {
    owner = "ProtonMail";
    repo = pname;
    rev = "v${version}";

    hash = "sha256-bynPuAdeX4WxYdbjMkR9ANuYWYOINB0OHnKTmIrCB6E=";
  };

  # subPackages = [ "cmd/Desktop-Bridge" ];

  vendorSha256 = "0lv4fwfmmqb7h8s9n801l1clx7dr2zdbnggr1wz6bbvi5gafasw3";

  buildPhase = ''
    mkdir -p "$out/bin"

    patchShebangs ./utils/credits.sh
    substituteInPlace Makefile \
      --replace "\$(shell git rev-parse --short=10 HEAD)" "${src.rev}" \
    # patchShebangs Makefile 
    
    make build-nogui

    cp ./proton-bridge "$out/bin/proton-bridge" 
  '';

  # buildPhase = ''
  #   mkdir -p $out/bin

  #   pushd $(mktemp -d)
  #   cp --recursive "$src/." .
  #   chmod --recursive +w .
  #   ls -lah

  #   pushd ./utils
  #   bash credits.sh bridge
  #   bash credits.sh importexport
  #   popd

  #   go install \
  #     -tags="" \
  #     -ldflags="-X github.com/ProtonMail/proton-bridge/internal/constants.Version=${version}-git \ 
  #       -X github.com/ProtonMail/proton-bridge/internal/constants.Revision=${src.rev}" \
  #     -v -p $NIX_BUILD_CORES \
  #     ./cmd/Desktop-Bridge 2>&1
  #     popd
  # '';

  doCheck = false;
}
