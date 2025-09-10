{
  lib,
  config,
  pkgs,
  ...
}:
let
  starshipDisabledMods = [
    "aws"
    "gcloud"
    "kubernetes"
    "docker_context"
    "container"
  ];
in
{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      dirHashes = {
        git = "$HOME/git";
        github = "$HOME/git/github.com";
        brainhive = "$HOME/git/github.com/brainhivenl";
        brainpod = "$HOME/git/github.com/brainpodnl";
      };
      history = {
        share = true;
        append = true;
        extended = true;
        ignoreDups = true;
        size = 10000000;
        save = 10000000;
      };
      envExtra = ''
        export FZF_CTRL_T_COMMAND=
      '';
    };

    autojump = {
      enable = true;
      enableZshIntegration = true;
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
    }
    // lib.genAttrs starshipDisabledMods (name: {
      disabled = true;
    });

    fzf.enable = true;
    fzf.enableZshIntegration = true;

    rio.enable = true;
    rio.settings = {
      theme = "nord";
      hide-mouse-cursor-when-typing = true;
      renderer.performance = "High";
      fonts = {
        family = "JetBrainsMono Nerd Font";
      };
      cursor = {
        shape = "underline";
        blinking = false;
      };
    };
  };
}
