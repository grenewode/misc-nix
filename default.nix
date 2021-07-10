{ pkgs ? import <nixpkgs> {} }:
{
  neovim = pkgs.callPackage ./neovim { };
  proton-bridge-cli = pkgs.callPackage ./proton-bridge/cli.nix { };
}
