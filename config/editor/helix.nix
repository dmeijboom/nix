{
  pkgs,
  ...
}:
let
  languageServers = [
    "nil"
    "buf"
    "sqls"
    "deno"
    "ruff"
    "gopls"
    "tombi"
    "vtsls"
    "rustup"
    "helm-ls"
    "pyrefly"
    "starpls"
    "marksman"
    "phpactor"
    "mdx-language-server"
    "lua-language-server"
    "vue-language-server"
    "bash-language-server"
    "emmet-language-server"
    "yaml-language-server"
    "prisma-language-server"
    "dockerfile-language-server"
    "tailwindcss-language-server"
    "vscode-langservers-extracted"
  ];
in
{
  home.packages =
    with pkgs;
    [
    ]
    ++ map (name: builtins.getAttr name pkgs) languageServers;

  programs.yazi = {
    enable = true;
    settings.mgr.show_symlink = false;
    plugins = with pkgs.yaziPlugins; {
      inherit nord full-border;
    };
    flavors = { inherit (pkgs.yaziPlugins) nord; };
    theme.flavor = {
      light = "nord";
      dark = "nord";
    };
    initLua = ''
      require("nord"):setup()
      require("full-border"):setup()
    '';
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages = {
      language-server.typescript-language-server = {
        command = "vtsls";
        args = [ "--stdio" ];
        config = {
          typescript = {
            updateImportsOnFileMove = {
              enabled = "always";
            };
            suggest = {
              completeFunctionCalls = true;
            };
          };
          inlayHints = {
            parameterNames.enabled = "all";
            parameterTypes.enabled = true;
            variableTypes.enabled = true;
            propertyDeclarationTypes.enabled = true;
            functionLikeReturnTypes = true;
            enumMemberValues.enabled = true;
          };
        };
      };
      language = [
        {
          name = "kcl";
          scope = "source.kcl";
          file-types = [ "k" ];
          roots = [ "kcl.mod" ];
          auto-format = true;
          injection-regex = "^kcl$";
        }
        {
          name = "tsx";
          language-servers = [
            "typescript-language-server"
            "tailwindcss-ls"
          ];
        }
        {
          name = "javascript";
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [
                "format"
                "diagnostics"
              ];
            }
            "vscode-eslint-language-server"
          ];
        }
        {
          name = "vue";
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [
                "format"
                "diagnostics"
              ];
            }
            "vscode-eslint-language-server"
          ];
        }
      ];
      grammar = [
        {
          name = "kcl";
          source = {
            git = "https://github.com/kcl-lang/tree-sitter-kcl";
            rev = "b0b2eb38009e04035a6e266c7e11e541f3caab7c";
          };
        }
      ];
    };
    settings = {
      theme = "nord-ext";
      keys.normal = {
        "," = {
          b = ":echo %sh{git blame -L %{cursor_line},+1 %{buffer_name}}";
          a = "code_action";
          f = ":format";
          e = [
            ":sh rm -f /tmp/tk-task"
            ":sh printf \"\x1b[<u\" > /dev/tty && tk --summary | fzf --height 20%% > /tmp/tk-task || true; printf \"\x1b[>1u\" > /dev/tty"
            ":sh test -s /tmp/tk-task && zellij run --close-on-exit --height 40%% --floating -- \"%sh{cat /tmp/tk-task}\""
            ":redraw"
          ];
        };
        "S-k" = "signature_help";
        "C-p" = "file_picker";
        "C-f" = [
          ":sh rm -f /tmp/unique-file"
          ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
          ":insert-output echo \"\x1b[?1049h\x1b[?2004h\" > /dev/tty"
          ":open %sh{cat /tmp/unique-file}"
          ":redraw"
        ];
      };
      editor = {
        true-color = true;
        undercurl = true;
        line-number = "relative";
        end-of-line-diagnostics = "hint";
        default-yank-register = "+";
        statusline = {
          left = [ "spinner" ];
          center = [ ];
          right = [
            "file-name"
            "position"
            "diagnostics"
          ];
        };
        cursor-shape = {
          normal = "underline";
        };
        auto-save = {
          after-delay = {
            enable = true;
            timeout = 1500;
          };
        };
        indent-guides = {
          render = true;
          character = "│";
        };
        lsp = {
          display-inlay-hints = true;
        };
      };
    };
    themes = {
      nord-ext = {
        inherits = "nord";
        "ui.statusline" = {
          fg = "#606a81";
          bg = "#2f343f";
        };
        "comment" = {
          fg = "nord3_bright";
          modifiers = [ ];
        };
        "ui.virtual.inlay-hint" = {
          fg = "nord3";
          modifiers = [ ];
        };
      };
    };
  };
}
