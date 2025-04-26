{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.kubie
    pkgs.mirrord
  ];
  home.shellAliases = {
    s = "lazygit";
  };
  home.stateVersion = "23.11";

  imports = [
    ./config/shell.nix
    ./config/git.nix
    ./config/editor.nix
  ];
}
