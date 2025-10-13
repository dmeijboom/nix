{
  lib,
  pkgs,
  ...
}:
let
  vim = import ../../lib/vim.nix { pkgs = pkgs; };

  simplePlugins = [
    "rest-nvim"
    "nvim-lspconfig"
    "vim-illuminate"
    "telescope-ui-select-nvim"
    "telescope-project-nvim"
    "telescope-github-nvim"
    "nvim-treesitter-textobjects"
  ];

  plugins = {
    multicursor-nvim = vim.mkPlugin { name = "multicursor-nvim"; };
    quicker-nvim = vim.mkPlugin { name = "quicker"; };
    nvim-surround = vim.mkPlugin { name = "nvim-surround"; };
    auto-save-nvim = vim.mkPlugin { name = "auto-save"; };
    which-key-nvim = vim.mkPlugin { name = "which-key"; };
    nvim-web-devicons = vim.mkPlugin { name = "nvim-web-devicons"; };

    gitsigns-nvim = vim.mkPlugin {
      name = "gitsigns"; 
      preview_config = {
        style = "minimal";
      };
    };

    indentmini-nvim = vim.mkPlugin {
      name = "indentmini";
      char = "│";
      src = pkgs.fetchFromGitHub {
        owner = "nvimdev";
        repo = "indentmini.nvim";
        rev = "0dc4bc2b3fc763420793e748b672292bc43ee722";
        sha256 = "sha256-iMQn9eJuwThatTg9aTKhgHQaBc1NV4h/6gGt+fhZG9k=";
      };
    };

    mdx-nvim = vim.mkPlugin {
      name = "mdx";
      src = pkgs.fetchFromGitHub {
        owner = "davidmh";
        repo = "mdx.nvim";
        rev = "464a74be368dce212cff02f6305845dc7f209ab3";
        sha256 = "sha256-jpMcrWx/Rg9sMfkQFXnIM8VB5qRuSB/70wuSh6Y5uFk=";
      };
    };

    guess-indent-nvim = vim.mkPlugin {
      name = "guess-indent";
      auto_cmd = true;
    };

    codecompanion-nvim = vim.mkPlugin {
      name = "codecompanion";
      strategies = {
        inline = {
          adapter = {
            name = "ollama";
            model = "qwen3-coder:30b";
          };
          keymaps = {
            accept_change = {
              modes = {
                n = "ga";
              };
              description = "Accept the suggested change";
            };
            reject_change = {
              modes = {
                n = "gr";
              };
              opts = {
                nowait = true;
              };
              description = "Reject the suggested change";
            };
          };
        };
        chat = {
          adapter = {
            name = "ollama";
            model = "qwen3-coder:30b";
          };
        };
      };
    };

    overseer-nvim = vim.mkPlugin {
      name = "overseer";
      autochdir = true;
    };

    nvim-treesitter = vim.mkPlugin {
      name = "nvim-treesitter.configs";
      auto_install = false;
      parser_install_dir = {
        _raw = "parser_install_dir";
      };
      highlight = {
        enable = true;
        additional_vim_regex_highlighting = false;
      };
    };

    blink-cmp = vim.mkPlugin {
      name = "blink.cmp";
      sources = {
        default = [
          "lsp"
          "buffer"
          "path"
          "snippets"
        ];
      };
      keymap = {
        preset = "default";
        "<Tab>" = [
          "select_and_accept"
          "fallback"
        ];
      };
      completion = {
        ghost_text = {
          enabled = true;
        };
        trigger = {
          show_on_keyword = true;
        };
        documentation = {
          auto_show = true;
        };
      };
      signature = {
        enabled = true;
      };
    };

    neogit = vim.mkPlugin {
      name = "neogit";
      kind = "vsplit";
      prompt_force_push = true;
      graph_style = "unicode";
      process_spinner = true;
      log_view = {
        kind = "vsplit";
      };
    };

    diffview-nvim = vim.mkPlugin {
      name = "diffview";
      use_icons = true;
    };

    nvim-tree-lua = vim.mkPlugin {
      name = "nvim-tree";
      renderer = {
        root_folder_label = ":t";
        icons = {
          glyphs = {
            git = {
              untracked = "";
            };
          };
        };
      };
    };

    telescope-nvim = vim.mkPlugin {
      name = "telescope";
      defaults = {
        winblend = 0;
        prompt_prefix = "";
        selection_caret = "";
        entry_prefix = "";
        borderchars = [
          "─"
          "│"
          "─"
          "│"
          "╭"
          "╮"
          "╯"
          "╰"
        ];
      };
      extensions = {
        ui-select = {
          _raw = "require('telescope.themes').get_dropdown {}";
        };
        project = {
          base_dirs = [
            {
              path = "~/git";
              max_depth = 4;
            }
            {
              path = "~/dev";
              max_depth = 2;
            }
          ];
          sync_with_nvim_tree = true;
          on_project_selected = {
            _raw = ''
              function(prompt_bufnr)
                local old=vim.fs.basename(vim.fn.getcwd())
                vim.cmd('mks! /tmp/.session_' .. old)

                require('telescope._extensions.project.actions').change_working_directory(prompt_bufnr, false)

                vim.cmd('NvimTreeToggle')
                vim.cmd('silent! bufdo bd')

                local new=vim.fs.basename(vim.fn.getcwd())

                if vim.fn.filereadable('/tmp/.session_' .. new) then
                  vim.cmd('silent! source /tmp/.session_' .. new)
                end
              end
            '';
          };
        };
      };
    };

    render-markdown-nvim = vim.mkPlugin {
      name = "render-markdown";
      heading = {
        enabled = false;
      };
      latex = {
        enabled = false;
      };
      completions = {
        blink = {
          enabled = true;
        };
        lsp = {
          enabled = true;
        };
      };
    };

    tiny-inline-diagnostic-nvim = vim.mkPlugin {
      name = "tiny-inline-diagnostic";
      preset = "simple";
      signs = {
        diag = "";
      };
    };

    gbprod-nord = vim.mkPlugin {
      name = "nord";
      styles = {
        comments = {
          italic = false;
        };
      };
    };
  };

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
    "marksman"
    "basedpyright"
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
      # Neovim utils
      fd
      bat
      ripgrep

      # Tree-sitter requirements
      go
      nodejs
      tree-sitter
    ]
    ++ map (name: builtins.getAttr name pkgs) languageServers;

  programs.neovim = {
    enable = true;
    extraLuaConfig = ''
      local parser_install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "treesitter")
      vim.opt.runtimepath:append(parser_install_dir)
    ''
    + (lib.concatStringsSep "\n" (
      lib.attrsets.mapAttrsToList (
        _: plugin: "require('${plugin.pluginName}').setup ${plugin.config}"
      ) plugins
    ))
    + "\n"
    + (builtins.readFile (
      pkgs.replaceVars ./neovim/init.lua (
        builtins.listToAttrs (
          map (name: {
            name = name;
            value = "${builtins.getAttr name pkgs}";
          }) languageServers
        )
      )
    ));
    plugins =
      map (name: pkgs.vimPlugins.${name}) simplePlugins
      ++ lib.attrsets.mapAttrsToList (name: plugin: plugin.setup name) plugins
      ++ (with pkgs.vimPlugins.nvim-treesitter-parsers; [
        bash
        c
        go
        html
        helm
        markdown
        markdown_inline
        ruby
        python
        rust
        http
        javascript
        typescript
        tsx
        yaml
        xml
        toml
        json
        nix
        prisma
      ]);
  };
}
