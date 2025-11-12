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

    mode = lib.mkOption {
      type = lib.types.enum [
        "client"
        "server"
      ];
      default = "client";
      description = "Installation mode";
    };

    cloud.enable = lib.mkEnableOption "Enable Kubernetes tools";
  };

  config = {
    home.emptyActivationPath = true;

    home.username = config.custom.username;
    home.homeDirectory =
      if pkgs.stdenv.isLinux then
        "/home/${config.custom.username}"
      else
        "/Users/${config.custom.username}";

    programs.home-manager.enable = pkgs.stdenv.isLinux;

    home.packages =
      with pkgs;
      [
        # Generic
        zsh
      ]
      ++ lib.optionals (config.custom.mode == "client") [
        # Git
        gh

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
    ./config/shell/alacritty.nix
    ./config/shell/k9s.nix
    ./config/shell/starship.nix
    ./config/shell/zellij.nix
    ./config/shell/zsh.nix
    ./config/shell/lazygit.nix
    ./config/git.nix
    ./config/cloud.nix
    ./config/editor/neovim.nix
    ./config/irc/ergo.nix
    ./config/irc/client.nix
  ];
}
