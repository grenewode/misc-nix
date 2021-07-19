{ nixpkgs ? <nixpkgs>
, nixpkgs-unstable ? (builtins.fetchTarball "https://releases.nixos.org/nixpkgs/nixpkgs-21.05pre277683.4e0d3868c67/nixexprs.tar.xz")
, system ? builtins.currentSystem
}:
let
  pkgs = import nixpkgs { inherit system; };
  unstable-pkgs = import nixpkgs-unstable { inherit system; };
in
{
  neovim = pkgs.callPackage ./neovim { };
  proton-bridge-cli = pkgs.callPackage ./proton-bridge/cli.nix { };
  wally = pkgs.callPackage ./zsa/wally { };
}
