{
  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs";
      flake-utils.url = "github:numtide/flake-utils";

      proton-bridge-src.url = "github:ProtonMail/proton-bridge?ref=v1.8.7";
      proton-bridge-src.flake = false;
    };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , ...
    }:
    {
      overlay = import ./overlay.nix;

    } //
    flake-utils.lib.eachDefaultSystem
      (
        system:
        let
          pkgs = import nixpkgs
            {
              inherit system;
              overlays = [ self.overlay ];
            };
        in
        {
          packages = { inherit (pkgs.grenewode) vim vimPlugins proton-bridge-cli; };
        }
      );
}
