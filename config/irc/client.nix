{
  lib,
  config,
  pkgs,
  ...
}:
let
  certDir = "${config.home.homeDirectory}/.certs/irc";
in
{
  config = lib.mkIf (config.custom.mode == "client") {
    programs = {
      tiny = {
        enable = true;
        settings = {
          servers = [{
            addr = "cloud.dillen.dev";
            port = 6697;
            tls = true;
            realname = "dmeijboom";
            nicks = ["dmeijboom"];
            join = ["#general" "#updates" "#testing"];
            sasl.pem = "${config.home.homeDirectory}/.certs/irc/client-with-key.pem";
          }];
          defaults = {
            nicks = ["dmeijboom"];
            realname = "dmeijboom";
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
              address = "cloud.dillen.dev";
              port = 6697;
              autoConnect = true;
              ssl = {
                enable = true;
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

    home.activation.installMkcertCA = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      export PATH="$PATH:/usr/bin"
      export CAROOT="${certDir}"

      if ! ${pkgs.mkcert}/bin/mkcert -check-ca &>/dev/null; then
        $VERBOSE_ECHO "Installing mkcert CA..."
        $DRY_RUN_CMD ${pkgs.mkcert}/bin/mkcert -install
      fi
    '';

    home.activation.generateCerts = lib.hm.dag.entryAfter [ "installMkcertCA" ] ''
      export CAROOT="${certDir}"
      export CERT_DIR="${certDir}"

      $DRY_RUN_CMD mkdir -p "$CERT_DIR"

      if [ ! -f "$CERT_DIR/client.pem" ]; then
        $VERBOSE_ECHO "Generating client certificate..."
        $DRY_RUN_CMD ${pkgs.mkcert}/bin/mkcert -client \
          -cert-file "$CERT_DIR/client.pem" -key-file "$CERT_DIR/client.key" \
          ${config.custom.username}

        $DRY_RUN_CMD ${pkgs.openssl}/bin/openssl x509 -in "$CERT_DIR/client.pem" -outform DER | \
          ${pkgs.coreutils}/bin/sha256sum | cut -d' ' -f1 > "$CERT_DIR/client-fingerprint.txt"

        $DRY_RUN_CMD cat "$CERT_DIR/client.pem" "$CERT_DIR/client.key" > "$CERT_DIR/client-with-key.pem"
      fi
    '';
  };
}
