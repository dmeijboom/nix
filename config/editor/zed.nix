{ config, pkgs, ... }:
{
  programs.zsh.initContent = ''
    export EDITOR="zed --wait"
  '';

  programs.zed-editor = {
    enable = true;
    installRemoteServer = pkgs.stdenv.isLinux;
    extensions = [
      "assembly"
      "atom"
      "basher"
      "bearded-icon-theme"
      "cue"
      "dart"
      "deno"
      "dockerfile"
      "elisp"
      "emmet"
      "fhir-shorthand"
      "fsh"
      "git-firefly"
      "helm"
      "html"
      "hurl"
      "ini"
      "jsonnet"
      "log"
      "make"
      "material-icon-theme"
      "mdx"
      "nix"
      "nord"
      "php"
      "pkl"
      "proto"
      "rego"
      "ron"
      "scheme"
      "sql"
      "starlark"
      "svelte"
      "tera"
      "terraform"
      "toml"
      "typst"
      "xml"
    ];
    userKeymaps = [
      {
        bindings = {
          cmd-t = "workspace::ToggleBottomDock";
        };
      }
      {
        bindings = {
          cmd-r = "task::Spawn";
        };
      }
      {
        bindings = {
          cmd-f = "workspace::ToggleLeftDock";
        };
      }
      {
        context = "ProjectPanel && not_editing";
        bindings = {
          "m n" = "project_panel::NewFile";
          r = "project_panel::Rename";
        };
      }
      {
        context = "Editor && vim_mode == normal";
        bindings = {
          ", w /" = "pane::SplitRight";
          ", w -" = "pane::SplitDown";
          ", w l" = "workspace::ActivateNextPane";
          ", w h" = "workspace::ActivatePreviousPane";
          ", r" = "editor::Rename";
          ", a" = "editor::ToggleCodeActions";
          ", f =" = "editor::Format";
          ", c" = "editor::ToggleFold";
          ", e n" = "editor::GoToDiagnostic";
          ", e N" = "editor::GoToPreviousDiagnostic";
        };
      }
      {
        bindings = {
          cmd-g = "git::Branch";
        };
      }
    ];
    userSettings = {
      load_direnv = "shell_hook";

      lsp = {
        deno = {
          settings = {
            deno = {
              enable = true;
              documentPreloadLimit = 15000;
              enablePaths = [ "web" ];
            };
          };
        };
        rust-analyzer = {
          binary = {
            path_lookup = true;
          };
        };
      };

      file_scan_exclusions = [
        "**/.git"
        "**/.svn"
        "**/.hg"
        "**/.jj"
        "**/CVS"
        "**/.DS_Store"
        "**/Thumbs.db"
        "**/.classpath"
        "**/.settings"
        "**/.direnv"
      ];

      edit_predictions = {
        mode = "subtle";
        copilot = {
          proxy = null;
          proxy_no_verify = null;
        };
        enabled_in_text_threads = false;
      };

      icon_theme = "Bearded Icon Theme";
      theme = "Nord";
      cursor_blink = false;
      cursor_shape = "underline";
      ensure_final_newline_on_save = true;

      experimental.theme_overrides = {
        "status_bar.background" = "#2e3440";
        hint = "#5c667a";
        predictive = "#5c667a";
      };

      buffer_font_family = "JetBrains Mono";

      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      vim_mode = true;
      vim = {
        toggle_relative_line_numbers = true;
        use_smartcase_find = true;
        use_system_clipboard = "always";
      };

      ui_font_size = 16;
      buffer_font_size = 16.0;

      tab_bar = {
        show = false;
      };

      autosave = {
        after_delay = {
          milliseconds = 500;
        };
      };

      outline_panel = {
        button = false;
      };
      collaboration_panel = {
        button = false;
      };
      project_panel = {
        button = false;
      };
      chat_panel = {
        button = "never";
      };
      notification_panel = {
        button = false;
      };

      features = {
        copilot = true;
        edit_prediction_provider = "copilot";
      };

      toolbar = {
        breadcrumbs = false;
        quick_actions = false;
        selections_menu = false;
      };

      git = {
        git_gutter = "tracked_files";
        gutter_debounce = null;
        inline_blame = {
          enabled = true;
          delay_ms = 750;
        };
      };

      terminal = {
        blinking = "off";
        button = false;
        toolbar = {
          breadcrumbs = false;
        };
      };

      gutter = {
        runnables = false;
        code_actions = false;
        folds = true;
      };

      current_line_highlight = "none";
      format_on_save = "off";

      agent = {
        default_model = {
          provider = "zed.dev";
          model = "claude-3-5-sonnet-latest";
        };
        button = false;
      };

      inlay_hints = {
        enabled = true;
        show_background = true;
      };

      languages = {
        JavaScript = {
          language_servers = [
            "deno"
            "typescript-language-server"
            "vtsls"
            "!eslint"
          ];
          formatter = "language_server";
        };
        TypeScript = {
          language_servers = [
            "deno"
            "!typescript-language-server"
            "!vtsls"
            "!eslint"
          ];
          formatter = "language_server";
        };
        Rust = {
          show_edit_predictions = true;
        };
        TSX = {
          inlay_hints = {
            enabled = true;
            show_type_hints = false;
          };
          language_servers = [
            "deno"
            "!typescript-language-server"
            "!vtsls"
            "!eslint"
          ];
          formatter = "language_server";
        };
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
        };
        Pkl = {
          tab_size = 2;
        };
      };

      file_types = {
        Helm = [
          "**/templates/**/*.tpl"
          "**/templates/**/*.yaml"
          "**/templates/**/*.yml"
          "**/helmfile.d/**/*.yaml"
          "**/helmfile.d/**/*.yml"
        ];
      };

      scrollbar = {
        show = "never";
      };
      preview_tabs = {
        enabled = false;
      };
      hide_mouse = "on_typing_and_movement";
    };
  };
}
