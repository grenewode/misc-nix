{ nixpkgs ? <nixpkgs>, system ? builtins.currentSystem }:
let pkgs = import nixpkgs { inherit system; };
in
{
  neovim = pkgs.callPackage ./neovim { };
  proton-bridge-cli = pkgs.callPackage ./proton-bridge/cli.nix { };
}
