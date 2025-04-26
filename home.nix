{ config, pkgs, ... }:
{
  home.packages = [
    # Kubernetes
    pkgs.kubie
    pkgs.kubernetes-helm
    pkgs.mirrord
    pkgs.skaffold
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
