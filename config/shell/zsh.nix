{
  lib,
  pkgs,
  config,
  ...
}:
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
        dmeijboom = "$HOME/git/github.com/dmeijboom";
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
      initContent = lib.mkIf (config.custom.mode == "client") ''
        zellij_update() {
          if [[ -n "$ZELLIJ_SESSION_NAME" ]]; then
            local zjstatus_prompt=$(starship prompt --profile zellij --terminal-width 80 | sed "s/%{//g; s/%}//g")
            local zjstatus_project=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")

            zellij action rename-tab "$zjstatus_project"
            echo -n "$zjstatus_prompt" > "/tmp/.zjstatus_''${ZELLIJ_SESSION_NAME}"
            zellij pipe zjstatus::rerun::command_termstate
          fi
        }

        chpwd_functions+=(zellij_update)
        precmd_functions+=(zellij_update)
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

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
