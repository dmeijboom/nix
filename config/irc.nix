{
  lib,
  pkgs,
  config,
  ...
}:
let
  dataDir = "${config.xdg.dataHome}/ergo";
  certDir = "${config.home.homeDirectory}/.certs/irc";

  ergo = pkgs.buildGoModule rec {
    pname = "ergo";
    version = "2.16.0";
    src = pkgs.fetchFromGitHub {
      owner = "ergochat";
      repo = "ergo";
      rev = "v${version}";
      sha256 = "sha256-AUXuH7YjC/yG5Ocs+kAOF8bAR4UVgfx96VDSHEqmqgg=";
    };
    doCheck = false;
    vendorHash = null;
  };

  ergoConfig = {
    network = {
      name = "atom";
    };

    server = {
      name = "cloud.dillen.dev";

      listeners = {
        ":6697" = {
          tls = {
            cert = "${config.home.homeDirectory}/.certs/irc/server.pem";
            key = "${config.home.homeDirectory}/.certs/irc/server.key";
          };
          proxy = false;
          min-tls-version = "1.2";
        };
      };

      unix-bind-mode = 0777;

      casemapping = "ascii";
      enforce-utf8 = true;
      lookup-hostnames = false;
      forward-confirm-hostnames = true;
      check-ident = false;
      coerce-ident = "~u";

      motd = "ergo.motd";
      motd-formatting = true;

      relaymsg = {
        enabled = true;
        separators = "/";
        available-to-chanops = true;
      };

      proxy-allowed-from = [
        "localhost"
      ];

      max-sendq = "96k";

      compatibility = {
        force-trailing = true;
        send-unprefixed-sasl = true;
        allow-truncation = false;
      };

      ip-limits = {
        count = true;
        max-concurrent-connections = 16;
        throttle = true;
        window = "10m";
        max-connections-per-window = 32;
        cidr-len-ipv4 = 32;
        cidr-len-ipv6 = 64;
        exempted = [
          "localhost"
        ];
      };

      ip-cloaking = {
        enabled = true;
        enabled-for-always-on = true;
        netname = "irc";
        cidr-len-ipv4 = 32;
        cidr-len-ipv6 = 64;
        num-bits = 64;
      };

      suppress-lusers = false;
    };

    accounts = {
      authentication-enabled = true;

      registration = {
        enabled = true;
        allow-before-connect = true;
        throttling = {
          enabled = true;
          duration = "10m";
          max-attempts = 30;
        };
        bcrypt-cost = 4;
        verify-timeout = "32h";
      };

      login-throttling = {
        enabled = true;
        duration = "1m";
        max-attempts = 3;
      };

      skip-server-password = false;
      login-via-pass-command = true;
      advertise-scram = true;

      require-sasl = {
        enabled = true;
        exempted = [
          "localhost"
        ];
      };

      nick-reservation = {
        enabled = true;
        additional-nick-limit = 0;
        method = "strict";
        allow-custom-enforcement = false;
        guest-nickname-format = "Guest-*";
        force-guest-format = false;
        force-nick-equals-account = true;
        forbid-anonymous-nick-changes = false;
      };

      multiclient = {
        enabled = true;
        allowed-by-default = true;
        always-on = "opt-out";
        auto-away = "opt-out";
      };

      vhosts = {
        enabled = true;
        max-length = 64;
        valid-regexp = "^[0-9A-Za-z.\\-_/]+$";
      };

      default-user-modes = "+i";
    };

    channels = {
      default-modes = "+ntC";
      max-channels-per-client = 100;
      operator-only-creation = false;

      registration = {
        enabled = true;
        operator-only = false;
        max-channels-per-account = 15;
      };

      list-delay = "0s";
      invite-expiration = "24h";
      auto-join = [ "#general" ];
    };

    oper-classes = {
      chat-moderator = {
        title = "Chat Moderator";
        capabilities = [
          "kill"
          "ban"
          "nofakelag"
          "relaymsg"
          "vhosts"
          "sajoin"
          "samode"
          "snomasks"
          "roleplay"
        ];
      };

      server-admin = {
        title = "Server Admin";
        extends = "chat-moderator";
        capabilities = [
          "rehash"
          "accreg"
          "chanreg"
          "history"
          "defcon"
          "massmessage"
          "metadata"
        ];
      };
    };

    opers = {
      admin = {
        class = "server-admin";
        hidden = true;
        whois-line = "is the server administrator";
        password = "$2a$04$0123456789abcdef0123456789abcdef0123456789abcdef01234";
      };
    };

    logging = [
      {
        method = "stderr";
        type = "* -userinput -useroutput";
        level = "info";
      }
    ];

    debug = {
      recover-from-errors = true;
    };

    lock-file = "${dataDir}/ircd.lock";

    datastore = {
      path = "${dataDir}/ircd.db";
      autoupgrade = true;
    };

    languages = {
      enabled = false;
      default = "en";
    };

    limits = {
      nicklen = 32;
      identlen = 20;
      realnamelen = 150;
      channellen = 64;
      awaylen = 390;
      kicklen = 390;
      topiclen = 390;
      monitor-entries = 100;
      whowas-entries = 100;
      chan-list-modes = 100;
      registration-messages = 1024;
      multiline = {
        max-bytes = 4096;
        max-lines = 100;
      };
    };

    fakelag = {
      enabled = true;
      window = "1s";
      burst-limit = 5;
      messages-per-window = 2;
      cooldown = "2s";
      command-budgets = {
        CHATHISTORY = 16;
        MARKREAD = 16;
        MONITOR = 1;
        WHO = 4;
        WEBPUSH = 1;
      };
    };

    history = {
      enabled = true;
      channel-length = 2048;
      client-length = 256;
      autoresize-window = "3d";
      autoreplay-on-join = 10;
      chathistory-maxmessages = 1000;
      znc-maxmessages = 2048;
      restrictions = {
        expire-time = "1w";
        query-cutoff = "none";
        grace-period = "1h";
      };
      retention = {
        allow-individual-delete = false;
        enable-account-indexing = false;
      };
      tagmsg-storage = {
        default = false;
        whitelist = [
          "+draft/react"
          "+react"
        ];
      };
    };

    allow-environment-overrides = true;

    metadata = {
      enabled = true;
      max-subs = 100;
      max-keys = 100;
    };
  };

  ergoConfigFile = pkgs.writeText "ergo-config.yaml" (builtins.toJSON ergoConfig);

  cmd = "${ergo}/bin/ergo run --conf ${ergoConfigFile}";
in
{
  config = {
    home.packages = lib.optionals (config.custom.mode == "server") [
      ergo
    ];

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

      # Generate server certificate
      if [ ! -f "$CERT_DIR/server.pem" ]; then
        $VERBOSE_ECHO "Generating server certificate..."
        $DRY_RUN_CMD ${pkgs.mkcert}/bin/mkcert \
          -cert-file "$CERT_DIR/server.pem" -key-file "$CERT_DIR/server.key" \
          localhost atom.localhost 127.0.0.1 ::1
      fi

      # Generate client certificate
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

    home.activation.createErgoDataDir = lib.mkIf (config.custom.mode == "server") (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p ${dataDir}
      ''
    );

    systemd.user.services.ergo = lib.mkIf (config.custom.mode == "server" && pkgs.stdenv.isLinux) {
      Unit = {
        Description = "Ergo reverse proxy service";
        After = [ "network.target" ];
      };

      Service = {
        ExecStart = cmd;
        Restart = "on-failure";
        RestartSec = "5s";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    launchd.agents.ergo = lib.mkIf (config.custom.mode == "server" && pkgs.stdenv.isDarwin) {
      enable = true;
      config = {
        ProgramArguments = lib.splitString " " cmd;
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/ergo.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/ergo.log";
      };
    };
  };
}
