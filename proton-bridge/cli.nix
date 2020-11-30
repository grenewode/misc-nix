{ buildGoModule
, fetchFromGitHub
, pkg-config
, libsecret
, qt5
, lib
}:
buildGoModule rec {
  pname = "protonmail-bridge";
  version = "1.5.2";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsecret ];

  src = fetchFromGitHub {
    owner = "ProtonMail";
    repo = "proton-bridge";

    rev = "br-1.5.2";

    hash = "sha256:1mv7fwapcarii43nnsgk7ifqlah07k54zk6vxxxmrp04gy0mzki6";
  };

  # subPackages = [ "cmd/Desktop-Bridge" ];

  vendorSha256 = "06yhv1f8kq16p4zbcw77gv8fna3s7vqxj14awsr5gcs947zf7w80";

  buildFlagsArray = [
    ''-tags="pmapi_prod nogui"''
    ''-ldflags="-X main.Version=${version} -X main.Revision=${src.rev}"''
    # ''-ldflags="-X main.Version=${version}"''
  ];

  buildPhase = ''
    mkdir -p $out

    go install \
      -tags="pmapi_prod nogui" \
      -ldflags="-X main.Version=${version}" \
      -v -p $NIX_BUILD_CORES \
      ./cmd/Desktop-Bridge 2>&1
  '';

  doCheck = false;
}
