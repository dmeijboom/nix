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
    "oxlint"
    "helm-ls"
    "pyrefly"
    "starpls"
    "marksman"
    "phpactor"
    "terraform-ls"
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
  home.packages = map (name: builtins.getAttr name pkgs) languageServers;

  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages = {
      language-server.oxlint = {
        command = "oxc_language_server";
      };

      language-server.typescript-language-server = {
        command = "vtsls";
        args = [ "--stdio" ];
        config = {
          vtsls = {
            tsserver = {
              globalPlugins = [
                {
                  name = "@vue/typescript-plugin";
                  languages = [ "vue" ];
                  configNamespace = "typescript";
                  location = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server";
                }
              ];
            };
          };
          typescript = {
            updateImportsOnFileMove = {
              enabled = "always";
            };
            suggest = {
              completeFunctionCalls = true;
            };
            inlayHints = {
              parameterNames = {
                enabled = "all";
              };
            };
          };
          javascript = {
            inlayHints = {
              parameterNames = {
                enabled = "all";
              };
            };
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
              except-features = [ "diagnostics" ];
            }
            "oxlint"
          ];
        }
        {
          name = "vue";
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [ "diagnostics" ];
            }
            "oxlint"
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
        space."=" = ":format";
        "S-k" = "signature_help";
        "C-p" = "file_picker";
        "C-f" = [
          ":sh rm -f /tmp/unique-file"
          ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
          ":insert-output echo \"\x1b[?1049h\x1b[?2004h\" > /dev/tty"
          ":open %sh{cat /tmp/unique-file}"
          ":redraw"
        ];
        "C-g" = {
          l = [
            ":write-all"
            ":new"
            ":insert-output lazygit log"
            ":set mouse false"
            ":set mouse true"
            ":buffer-close!"
            ":redraw"
            ":reload-all"
          ];
          s = [
            ":write-all"
            ":new"
            ":insert-output lazygit"
            ":set mouse false"
            ":set mouse true"
            ":buffer-close!"
            ":redraw"
            ":reload-all"
          ];
        };
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
