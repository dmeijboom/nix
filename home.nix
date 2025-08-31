{ lib, config, pkgs, ... }:
{
  options.custom = {
    cloud.enable = lib.mkEnableOption "Kubernetes tools";
  };

  config = {
    home.username = "dmeijboom";
    home.homeDirectory =
      if pkgs.stdenv.isLinux
      then "/home/dmeijboom"
      else "/Users/dmeijboom";

    programs.home-manager.enable = pkgs.stdenv.isLinux;

    home.packages = with pkgs; [
      # Generic
      zsh

      # Build tools
      devenv
      bazelisk
      buildifier
      buildozer
      skaffold

      # Misc tools
      duckdb
      ast-grep

      # Hacks
      rustup
    ];

    home.shellAliases = {
      s = "lazygit";
      bazel = "bazelisk";
    };
    home.stateVersion = "23.11";
  };

  imports = [
    ./config/shell.nix
    ./config/git.nix
    ./config/editor.nix
    ./config/cloud.nix
  ];
}
