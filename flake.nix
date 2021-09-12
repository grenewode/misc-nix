{
  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs";
      flake-utils.url = "github:numtide/flake-utils";

      ale-src = {
        type = "github";
        owner = "dense-analysis";
        repo = "ale";
        ref = "v3.1.0";
        flake = false;
      };

      proton-bridge-src.url = "github:ProtonMail/proton-bridge?ref=v1.8.7";
      proton-bridge-src.flake = false;
    };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , ale-src
    , proton-bridge-src
    , ...
    }:
    flake-utils.lib.eachDefaultSystem
      (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        rec {
          packages = {
            ale = pkgs.vimUtils.buildVimPluginFrom2Nix {
              pname = "ale";
              version = "3.1.0";
              src = pkgs.lib.traceVal ale-src;
              meta.homepage = "https://github.com/dense-analysis/ale/";
            };
            neovim = pkgs.callPackage ./neovim { ale = packages.ale; };
            proton-bridge-cli = pkgs.callPackage ./proton-bridge/cli.nix { inherit proton-bridge-src; };
          };
        }
      );
}
