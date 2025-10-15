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
            address = "atom.localhost";
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
    replaces = { };
    abstracts = {
      line_start = "";
      timestamp = "%K$0%n";
      hilight = "%b$0%n";
      error = "%R$0-%n";
      channel = "%b$0-%n";
      nick = "%_$0-%_";
      nickhost = "%n%9[%_$0-%9]%_";
      server = "$0-";
      comment = "[$0-]";
      reason = "($0-)";
      mode = "%r$0-%n";

      channick_hilight = "%B$0-%n";
      chanhost_hilight = "{nickhost $0-}";
      channick = "%b$0-";
      chanhost = "{nickhost $0-}";
      channelhilight = "%_$0-%_";
      ban = "$0-";

      msgnick = "$_%b$0%n$1-%9:%n %|";

      ownmsgnick = "%b$0%n$1%n%R:%n %|";
      ownnick = "$0-";
      pubmsgnick = "{msgnick $0 $1-}";
      pubnick = "$0-";
      pubmsgmenick = "%b$0%r$1-%b%9:%n %|";
      menick = "$0-";
      pubmsghinick = "%b$1$2-: %|";
      msgchannel = "%w|%c$0-";
      privmsg = "<-%c$0%n[%C$1%n] ";
      ownprivmsg = "->[%c$1-%n] $0";
      ownprivmsgnick = "{ownmsgnick = %C$0-%n}";
      ownprivnick = "$0-";
      privmsgnick = "{msgnick = %C$0-%n}";

      action_core = "%b*%n $0-";
      action = "{action_core $0-} ";
      ownaction = "{action $0-}";
      ownaction_target = "{action_core $0}{msgchannel $1} ";
      pvtaction = " %g(*) $0- ";
      pvtaction_query = "{action $0-}";
      pubaction = "{action $0-}";

      ownnotice = "-> %gnotice%n[%G$1%n] ";
      notice = "<- %Gnotice%n[%g$0%n] ";
      pubnotice_channel = "{msgchannel $0}";
      pvtnotice_host = "";
      servernotice = "{notice $0-}";
      ownctcp = "-> %b$0%n[%B$1-%n] ";
      ctcp = "%B$0-";
      wallop = "%y$0-: %n";
      wallop_nick = "%y$0-%n";
      wallop_action = "%y * $0-%n ";
      netsplit = "%M%%%r $0-%n";
      netjoin = "%M%%%b $0-%n";
      names_nick = "  %b$0%n$1";
      names_users = "%M#%b $0-";
      names_channel = "{channel $0-}";
      dcc = "$0-";
      dccfile = "%_$0-%_";
      dccownmsg = "*%c=$1-%n*> %g";
      dccownaction = "{action $0-}";
      dccownaction_target = "{ownaction_target $0-}";
      dccmsg = "*%c=$1-%n* ";
      dccquerynick = "$0-";
      dccaction = " (*dcc*) $0- %|";
      sb_background = "%n";
      sb_window_bg = "%n";
      sb_prompt_bg = "%n";
      sb_info_bg = "%5";
      sb_topic_bg = "%K%W";
      sbstart = "";
      sbend = " ";
      prompt = "{channel $*}%n%9>%_ ";
      sb = " %n$*%w |";
      sbmode = " (%b+%n$*)";
      sbaway = " %nis away";
      sbservertag = ":$0 (change with ^X)";

      sb_act_sep = "%k$*";
      sb_act_text = "%k$*";
      sb_act_msg = "%R$*";
      sb_act_hilight = "%M$*";
      sb_act_hilight_color = "$0$1-%n";

    };
    formats = {
      "fe-common/core" = {
        join = "%M+%n {channick_hilight $0} {chanhost_hilight $1} joined {channel $2}";
        part = "%M-%n {channick $0} {chanhost $1} left {channel $2} {reason $3}";
        kick = "%M!%n {channick $0} was kicked from {channel $1} by {nick $2} {reason $3}";
        quit = "%M=%n {channick $0} {chanhost $1} quit {reason $2}";
      };
      "fe-common/irc" = {
        chanmode_change = "%M~%n {nick $2} set {mode $1} on {channel $0}";
        whois = "{nick $0} {nickhost $1@$2}%: ircname : $3";
        server_chanmode_change = "{netsplit ServerMode}/{channelhilight $0}: {mode $1} by {nick $2}";
      };
    };
  '';
}
