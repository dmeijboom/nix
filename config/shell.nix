{ config, pkgs, ... }:
{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      history = {
        share = true;
        append = true;
        extended = true;
        ignoreDups = true;
        size = 10000000;
        save = 10000000;
      };
      initContent = ''
        export EDITOR="zed --wait"
      '';
    };

    direnv = {
      enable = true;
      silent = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    starship.enable = true;
    starship.enableZshIntegration = true;
    starship.settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
        vicmd_symbol = "[V](bold green)";
      };
      aws = {
        disabled = true;
      };
      gcloud = {
        disabled = true;
      };
      kubernetes = {
        disabled = false;
      };
      docker_context = {
        disabled = true;
      };
    };

    rio.enable = true;
    rio.settings = {
      theme = "nord";
      cursor = {
        shape = "underline";
        blinking = false;
      };
    };
  };
}
