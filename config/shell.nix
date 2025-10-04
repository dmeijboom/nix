{
  lib,
  ...
}:
let
  starshipDisabledMods = [
    "aws"
    "gcloud"
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
        export KONSOLE_VERSION="230804"
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
      kubernetes = {
        disabled = false;
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
      option-as-alt = "both";
      fonts = {
        family = "JetBrainsMono Nerd Font";
      };
      cursor = {
        shape = "underline";
        blinking = false;
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
                defaultDialColors = [ "#88C0D0" "#BF616A" ];
                defaultChartColors = [ "#88C0D0" "#BF616A" ];
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
