{ buildGoModule
, fetchFromGitHub
, pkg-config
, libsecret
, qt5
, lib
}:
buildGoModule rec {
  pname = "proton-bridge";
  version = "1.5.2";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsecret ];

  src = fetchFromGitHub {
    owner = "ProtonMail";
    repo = "proton-bridge";

    rev = "br-${version}";

    hash = "sha256:1mv7fwapcarii43nnsgk7ifqlah07k54zk6vxxxmrp04gy0mzki6";
  };

  # subPackages = [ "cmd/Desktop-Bridge" ];

  vendorSha256 = "01d6by8xj9py72lpfns08zqnsym98v8imb7d6hgmnzp4hfqzbz3c";

  buildPhase = ''
    mkdir -p $out

    go install \
      -tags="pmapi_prod nogui" \
      -ldflags="-X github.com/ProtonMail/proton-bridge/pkg/constants.Version=${version}-git -X github.com/ProtonMail/proton-bridge/pkg/constants.Revision=${src.rev}" \
      -v -p $NIX_BUILD_CORES \
      ./cmd/Desktop-Bridge 2>&1


  '';

  doCheck = false;
}
