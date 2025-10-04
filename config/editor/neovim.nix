{
  lib,
  pkgs,
  ...
}:
let
  lua = import ../../lib/lua.nix { lib = lib; };
  mkPlugin = (
    name: config: {
      name = name;
      pluginName = config.name;
      setup = lua.serialize (removeAttrs config [ "name" ]);
    }
  );

  indentmini-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "indentmini";
    src = pkgs.fetchFromGitHub {
      owner = "nvimdev";
      repo = "indentmini.nvim";
      rev = "0dc4bc2b3fc763420793e748b672292bc43ee722";
      sha256 = "sha256-iMQn9eJuwThatTg9aTKhgHQaBc1NV4h/6gGt+fhZG9k=";
    };
  };

  mdx-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "mdx";
    src = pkgs.fetchFromGitHub {
      owner = "davidmh";
      repo = "mdx.nvim";
      rev = "464a74be368dce212cff02f6305845dc7f209ab3";
      sha256 = "sha256-jpMcrWx/Rg9sMfkQFXnIM8VB5qRuSB/70wuSh6Y5uFk=";
    };
  };

  mini-icons = mkPlugin "mini-icons" { name = "mini.icons"; };
  quicker-nvim = mkPlugin "quicker-nvim" { name = "quicker"; };
  gitsigns-nvim = mkPlugin "gitsigns-nvim" { name = "gitsigns"; };
  nvim-surround = mkPlugin "nvim-surround" { name = "nvim-surround"; };
  auto-save-nvim = mkPlugin "auto-save-nvim" { name = "auto-save"; };
  nvim-web-devicons = mkPlugin "nvim-web-devicons" { name = "nvim-web-devicons"; };
  guess-indent-nvim = mkPlugin "guess-indent-nvim" {
    name = "guess-indent";
    auto_cmd = true;
  };
  codecompanion-nvim = mkPlugin "codecompanion-nvim" {
    name = "codecompanion";
    strategies = {
      inline = {
        adapter = {
          name = "ollama";
          model = "qwen3-coder:30b";
        };
        keymaps = {
          accept_change = {
            modes = { n = "ga"; };
            description = "Accept the suggested change";
          };
          reject_change = {
            modes = { n = "gr"; };
            opts = { nowait = true; };
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
  overseer-nvim = mkPlugin "overseer-nvim" {
    name = "overseer";
    autochdir = true;
  };
  nvim-treesitter = mkPlugin "nvim-treesitter" {
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
  blink-cmp = mkPlugin "blink-cmp" {
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
  neogit = mkPlugin "neogit" {
    name = "neogit";
    kind = "vsplit";
    prompt_force_push = true;
    graph_style = "unicode";
    process_spinner = true;
    log_view = {
      kind = "vsplit";
    };
  };
  diffview-nvim = mkPlugin "diffview-nvim" {
    name = "diffview";
    use_icons = true;
  };
  nvim-tree-lua = mkPlugin "nvim-tree-lua" {
    name = "nvim-tree";
    renderer = {
      root_folder_label = ":t";
    };
  };
  telescope-nvim = mkPlugin "telescope-nvim" {
    name = "telescope";
    defaults = {
      winblend = 0;
      prompt_prefix = "";
      selection_caret = "";
      entry_prefix = "";
      borderchars = [ "─" "│" "─" "│" "╭" "╮" "╯" "╰" ];
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
  render-markdown-nvim = mkPlugin "render-markdown-nvim" {
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
  tiny-inline-diagnostic-nvim = mkPlugin "tiny-inline-diagnostic-nvim" {
    name = "tiny-inline-diagnostic";
    preset = "simple";
    signs = {
      diag = "";
    };
    options = {
      # add_messages = false;
      # multilines = true;
    };
  };
  which-key-nvim = mkPlugin "which-key-nvim" { name = "which-key"; };
  gbprod-nord = mkPlugin "gbprod-nord" {
    name = "nord";
    styles = {
      comments = {
        italic = false;
      };
    };
  };

  plugins = [
    "rest-nvim"
    "nvim-lspconfig"
    "vim-illuminate"
    "telescope-ui-select-nvim"
    "telescope-project-nvim"
    "nvim-treesitter-textobjects"
    guess-indent-nvim
    codecompanion-nvim
    nvim-treesitter
    blink-cmp
    quicker-nvim
    overseer-nvim
    gitsigns-nvim
    which-key-nvim
    tiny-inline-diagnostic-nvim
    nvim-web-devicons
    nvim-surround
    mini-icons
    auto-save-nvim
    nvim-tree-lua
    telescope-nvim
    render-markdown-nvim
    gbprod-nord
    diffview-nvim
    neogit
  ];

  languageServers = [
    "nil"
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
    "dockerfile-language-server"
    "tailwindcss-language-server"
    "vscode-langservers-extracted"
  ];

  pluginsToSetup = builtins.filter (plugin: builtins.isAttrs plugin) plugins;
  pluginNames = map (plugin: if builtins.isAttrs plugin then plugin.name else plugin) plugins;
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
      map (plugin: "require('${plugin.pluginName}').setup ${plugin.setup}") pluginsToSetup
    ))
    + "\n"
    + (builtins.readFile (
      pkgs.replaceVars ./neovim/init.lua (
        builtins.listToAttrs (map (name: {
          name = name;
          value = "${builtins.getAttr name pkgs}";
        }) languageServers)
      )
    ));
    plugins =
      with pkgs.vimPlugins;
      map (name: pkgs.vimPlugins.${name}) pluginNames
      ++ [ mdx-nvim indentmini-nvim ]
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
      ]);
  };
}
