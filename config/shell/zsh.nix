{
  lib,
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
        wellsync = "$HOME/git/github.com/wellsync";
        brainpod = "$HOME/git/github.com/brainpodnl";
        dmeijboom = "$HOME/git/github.com/dmeijboom";
        brainhive = "$HOME/git/github.com/brainhivenl";
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
        export PATH="$HOME/.local/bin:$PATH"
      '';
      initContent = lib.mkMerge [
        (lib.mkIf (config.custom.mode == "client") ''
          zellij_update() {
            if [[ -n "$ZELLIJ_SESSION_NAME" ]]; then
              local zjstatus_prompt=$(starship prompt --profile zellij --terminal-width 80 | sed "s/%{//g; s/%}//g")
              local zjstatus_project=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")

              zellij action rename-tab "$zjstatus_project" 2>/dev/null
              echo -n "$zjstatus_prompt" > "/tmp/.zjstatus_''${ZELLIJ_SESSION_NAME}"
              zellij pipe zjstatus::rerun::command_termstate 2>/dev/null
            fi
          }

          chpwd_functions+=(zellij_update)
          precmd_functions+=(zellij_update)
        '')
        (lib.mkOrder 1500 ''
          bindkey '^T' fzf-file-widget
        '')
      ];
    };

    zoxide = {
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
      defaultCommand = "fd --type f --hidden --exclude .git";
      fileWidgetCommand = "fd --type f --hidden --exclude .git";
      fileWidgetOptions = [ "--preview 'bat --color=always --style=numbers --line-range=:200 {}'" ];
      changeDirWidgetCommand = "fd --type d --hidden --exclude .git";
      defaultOptions = [
        "--color=fg:#D8DEE9,bg:#2E3440,hl:#88C0D0"
        "--color=fg+:#ECEFF4,bg+:#3B4252,hl+:#8FBCBB"
        "--color=info:#81A1C1,prompt:#BF616A,pointer:#B48EAD"
        "--color=marker:#A3BE8C,spinner:#B48EAD,header:#88C0D0"
      ];
    };
  };
}
