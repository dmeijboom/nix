{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "dmeijboom";
      description = "Username";
    };
    vscode.enable = lib.mkEnableOption "Enable vscode";
    cloud.enable = lib.mkEnableOption "Kubernetes tools";
  };

  config = {
    home.username = config.custom.username;
    home.homeDirectory =
      if pkgs.stdenv.isLinux then
        "/home/${config.custom.username}"
      else
        "/Users/${config.custom.username}";

    programs.home-manager.enable = pkgs.stdenv.isLinux;

    home.packages = with pkgs; [
      # Generic
      zsh

      # Build tools
      devenv
      bazelisk
      buildifier
      buildozer

      # Misc tools
      duckdb
      ast-grep

      # Hacks
      rustup

      # Fonts
      nerd-fonts.jetbrains-mono
    ];

    home.shellAliases = {
      sg = "ast-grep";
      bazel = "bazelisk";
    };

    home.stateVersion = "23.11";
  };

  imports = [
    ./config/shell.nix
    ./config/git.nix
    ./config/cloud.nix
    ./config/editor/zed.nix
    ./config/editor/neovim.nix
    ./config/shell/zellij.nix
    ./config/shell/starship.nix
  ];
}
