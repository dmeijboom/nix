{
  lib,
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
      initContent = ''
        update_status() {
          ZELLIJ_STATUS=$(starship prompt --profile zellij --terminal-width 80 | sed "s/%{//g; s/%}//g")
          zellij pipe zjstatus::pipe::pipe_status::"$ZELLIJ_STATUS" 2>/dev/null
        }

        precmd_functions+=(update_status)
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

    fzf.enable = true;
    fzf.enableZshIntegration = true;

    alacritty = {
      enable = true;
      theme = "nord";
      settings = {
        env.KONSOLE_VERSION = "230804";
        general.live_config_reload = true;
        mouse.hide_when_typing = true;
        window = {
          decorations = "None";
          startup_mode = "Maximized";
          option_as_alt = "OnlyLeft";
          padding = {
            x = 8;
            y = 8;
          };
        };
        font = {
          size = 14;
          normal.family = "JetBrainsMono Nerd Font";
          bold.family = "JetBrainsMono Nerd Font";
          italic.family = "JetBrainsMono Nerd Font";
          bold_italic.family = "JetBrainsMono Nerd Font";
        };
        cursor.style = {
          shape = "Underline";
          blinking = "Never";
        };
      };
    };

    k9s = {
      enable = true;
      settings = {
        skin = "nord";
        skipLatestRevCheck = false;
        k9s = {
          ui = {
            crumbsless = true;
            logoless = true;
            headless = true;
            noIcons = true;
          };
        };
      };
      skins = {
        nord = {
          k9s = {
            body = {
              fgColor = "#D8DEE9";
              bgColor = "#2E3440";
              logoColor = "#5E81AC";
            };

            info = {
              fgColor = "#88C0D0";
              sectionColor = "#D8DEE9";
            };

            dialog = {
              fgColor = "#D8DEE9";
              bgColor = "#2E3440";
              buttonFgColor = "#D8DEE9";
              buttonBgColor = "#3B4252";
              buttonFocusFgColor = "#D8DEE9";
              buttonFocusBgColor = "#3B4252";
              labelFgColor = "#88C0D0";
              fieldFgColor = "#BF616A";
            };

            frame = {
              border = {
                fgColor = "#5E81AC";
                focusColor = "#5E81AC";
              };

              menu = {
                fgColor = "#D8DEE9";
                keyColor = "#A3BE8C";
                numKeyColor = "#A3BE8C";
              };

              crumbs = {
                fgColor = "#D8DEE9";
                bgColor = "#2E3440";
                activeColor = "#3B4252";
              };

              status = {
                newColor = "#88C0D0";
                modifyColor = "#EBCB8B";
                addColor = "#A3BE8C";
                pendingColor = "#EBCB8B";
                errorColor = "#BF616A";
                highlightcolor = "#88C0D0";
                killColor = "#A3BE8C";
                completedColor = "#5E81AC";
              };

              title = {
                fgColor = "#D8DEE9";
                bgColor = "#2E3440";
                highlightColor = "#88C0D0";
                counterColor = "#88C0D0";
                filterColor = "#EBCB8B";
              };
            };

            views = {
              charts = {
                bgColor = "#2E3440";
                dialBgColor = "#2E3440";
                chartBgColor = "#2E3440";
                defaultDialColors = [
                  "#88C0D0"
                  "#BF616A"
                ];
                defaultChartColors = [
                  "#88C0D0"
                  "#BF616A"
                ];
              };

              table = {
                fgColor = "#D8DEE9";
                bgColor = "#2E3440";
                cursorFgColor = "#2E3440";
                cursorBgColor = "#2E3440";
                markColor = "#D8DEE9";

                header = {
                  fgColor = "#D8DEE9";
                  bgColor = "#2E3440";
                  sorterColor = "#88C0D0";
                };
              };

              xray = {
                fgColor = "#D8DEE9";
                bgColor = "#2E3440";
                cursorColor = "#88C0D0";
                cursorTextColor = "#D8DEE9";
                graphicColor = "#88C0D0";
              };

              yaml = {
                keyColor = "#88C0D0";
                colonColor = "#88C0D0";
                valueColor = "#D8DEE9";
              };

              logs = {
                fgColor = "#D8DEE9";
                bgColor = "#2E3440";

                indicator = {
                  fgColor = "#D8DEE9";
                  bgColor = "#5E81AC";
                };
              };
            };
          };
        };
      };
    };
  };
}
