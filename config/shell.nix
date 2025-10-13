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

    irssi = {
      enable = true;
      networks = {
        atom = {
          nick = config.custom.username;
          autoCommands = [
            "/ignore -levels CRAP *"
          ];
          server = {
            address = "localhost";
            port = 6697;
            autoConnect = true;
            ssl = {
              enable = true;
              verify = false;
              certificateFile = "${config.home.homeDirectory}/.certs/irc/client-with-key.pem";
            };
          };
          channels = {
            general.autoJoin = true;
          };
          saslExternal = true;
        };
      };
      extraConfig = ''
        settings = {
          "fe-common/core" = { theme = "nord"; };
        }
      '';
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

  home.file.".irssi/nord.theme".text = ''
    default_color = "-1";
    info_eol = "false";
    replaces = { "[]=" = "%_$*%_"; };

    abstracts = {
      line_start = "";
      timestamp = "%K$*%n";
      hilight = "%_$*%_";
      error = "%R$*%n";
      channel = "%_$*%_";
      nick = "%_$*%_";
      nickhost = "❬$*❭";
      server = "%_$*%_";
      comment = "($*)";
      reason = "{comment $*}";
      mode = "{comment $*}";
      channick_hilight = "%c$*%K";
      chanhost_hilight = "{nickhost $*}";
      channick = "$*";
      chanhost = "{nickhost $*}";
      channelhilight = "%c$*%n";
      ban = "%R$*%n";
      msgnick = "%b%_%b$0$1-%_%w %|";
      ownmsgnick = "{msgnick $0 $1-}%b";
      ownnick = "%b$*%n";
      pubmsgnick = "{msgnick $0 $1-}";
      pubnick = "%b%_$*%_%n";
      pubmsgmenick = "{msgnick $0 $1-}";
      menick = "%m$*%n";
      pubmsghinick = "{msgnick $1 $0$2-%n}";
      msgchannel = "%K:%c$*%n";
      privmsg = "[%m$0%K❬%n$1-%K❭%n] ";
      ownprivmsg = "[%b$0%K❬%B$1-%K❭%n] ";
      ownprivmsgnick = "{msgnick  $*}%b";
      ownprivnick = "%b$*%n";
      privmsgnick = "{msgnick  %m$*%n}%m";
      action_core = "%_*%n $*";
      action = "{action_core %_$*%n} ";
      ownaction = "{action_core %b$*%n} ";
      ownaction_target = "{action_core $0}%K:%b$1%n ";
      pvtaction = "%M (*) $*%n ";
      pvtaction_query = "{action $*}";
      pubaction = "{action $*}";
      whois = "%# $[8]0 : $1-";
      ownnotice = "[%b$0%K(%b$1-%K)]%n ";
      notice = "%K-%M$*%K-%n ";
      pubnotice_channel = "%K:%m$*";
      pvtnotice_host = "%K(%m$*%K)";
      servernotice = "%g!$*%n ";
      ownctcp = "[%b$0%K(%b$1-%K)] ";
      ctcp = "%g$*%n";
      wallop = "%c$*%n: ";
      wallop_nick = "%n$*";
      wallop_action = "%c * $*%n ";
      netsplit = "%r$*%n";
      netjoin = "%g$*%n";
      names_prefix = "";
      names_nick = "[%_$0%_$1-] ";
      names_nick_op = "{names_nick $*}";
      names_nick_halfop = "{names_nick $*}";
      names_nick_voice = "{names_nick $*}";
      names_users = "[%g$*%n]";
      names_channel = "%c$*%n";
      dcc = "%g$*%n";
      dccfile = "%_$*%_";
      dccownmsg = "[%b$0%K❬$1-%K❭%n] ";
      dccownnick = "%b$*%n";
      dccownquerynick = "%c$*%n";
      dccownaction = "{action $*}";
      dccownaction_target = "{action_core $0}%K:%c$1%n ";
      dccmsg = "[%g$1-%K❬$0%K❭%n] ";
      dccquerynick = "%g$*%n";
      dccaction = "%c (*dcc*) $*%n %|";
      
      # Minimal statusbar colors - dark and subtle
      sb_background = "%K";
      sb_default_bg = "%K";
      sb_topic_bg = "%K";
      sb_window_bg = "%K";
      sb_prompt_bg = "%K";
      sb_info_bg = "%K";
      
      sbstart = "";
      sbend = " ";
      topicsbstart = "{sbstart $*}";
      topicsbend = "{sbend $*}";
      prompt = "%c$*%n> ";
      
      # Statusbar with subtle nerd font icons
      sb = " $* %K│%n";
      sbmode = "%K(%n$*%K)%n";
      sbaway = " %K󰒲%n";
      sbservertag = ":%K$0%n";
      sbnickmode = "$0";
      sb_act_sep = "%K$*";
      sb_act_text = "%w$*";
      sb_act_msg = "%Y$*";
      sb_act_hilight = "%R$*";
      sb_act_hilight_color = "$0$1-%n";
      sb_usercount = "{sb %_$0%_ %K󰀄%n %K$1-%n}";
      sb_uc_ircops = "%K⚡%n$*";
      sb_uc_ops = "%K@%n$*";
      sb_uc_halfops = "%K%%%n$*";
      sb_uc_voices = "%K+%n$*";
      sb_uc_normal = "$*";
    };

    formats = {
      "fe-common/core" = {
        daychange = "           %K─────%w─%W─%n Day changed to %%D %W─%w─%K─────%n";
      };
    };
  '';
}
