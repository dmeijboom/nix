{
  lib,
  config,
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

  kubectl-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "kubectl-nvim";
    nvimRequireCheck = "kubectl";
    src = pkgs.fetchFromGitHub {
      owner = "Ramilito";
      repo = "kubectl.nvim";
      rev = "318057aab0cd0ca69273e55b9cebc01c78f9a9ab";
      sha256 = "sha256-nxF1oeswhzENSsjSdDvqeBsbm0NraVVFBwRdIFDf930=";
    };
  };

  quicker-nvim = mkPlugin "quicker-nvim" { name = "quicker"; };
  gitsigns-nvim = mkPlugin "gitsigns-nvim" { name = "gitsigns"; };
  nvim-web-devicons = mkPlugin "nvim-web-devicons" { name = "nvim-web-devicons"; };
  nvim-surround = mkPlugin "nvim-surround" { name = "nvim-surround"; };
  mini-icons = mkPlugin "mini-icons" { name = "mini.icons"; };
  auto-save-nvim = mkPlugin "auto-save-nvim" { name = "auto-save"; };
  blink-copilot = mkPlugin "blink-copilot" { name = "blink-copilot"; };
  blink-cmp = mkPlugin "blink-cmp" {
    name = "blink.cmp";
    sources = {
      default = ["lsp" "buffer"];
      providers = {
        copilot = {
          name = "copilot";
          module = "blink-copilot";
          async = true;
        };
      };
    };
    keymap = {
      preset = "default";
      "<Tab>" = ["select_and_accept" "fallback"];
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
    log_view = { kind = "vsplit"; };
  };
  diffview-nvim = mkPlugin "diffview-nvim" {
    name = "diffview"; 
    use_icons = true;
  };
  copilot-lua = mkPlugin "copilot-lua" {
    name = "copilot";
    copilot_node_command = "${pkgs.nodejs}/bin/node";
    suggestion = { enabled = false; };
    panel = { enabled = false; };
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
      border = false;
    };
    extensions = {
      ui-select = {
        _raw = "require('telescope.themes').get_cursor {}";
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
              close_terminal()
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
    completions = {
      blink = {
        enabled = true;
      };
      lsp = {
        enabled = true;
      };
    };
  };
  trouble-nvim = mkPlugin "trouble-nvim" {
    name = "trouble";
    modes = {
      diagnostics = {
        auto_open = false;
        auto_close = true;
        preview = {
          scratch = false;
        };
      };
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
  indent-blankline-nvim-lua = mkPlugin "indent-blankline-nvim-lua" {
    name = "ibl";
    scope = {
        show_start = false;
        show_end = false;
        highlight = "IblScope";
    };
    indent = {
        char = "│";
    };
  };

  plugins = [
    "nvim-treesitter"
    "nvim-lspconfig"
    "vim-illuminate"
    "telescope-ui-select-nvim"
    "telescope-project-nvim"
    copilot-lua
    blink-copilot
    blink-cmp
    indent-blankline-nvim-lua
    quicker-nvim
    gitsigns-nvim
    which-key-nvim
    trouble-nvim
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

  pluginsToSetup = builtins.filter (plugin: builtins.isAttrs plugin) plugins;
  pluginNames = map (plugin: if builtins.isAttrs plugin then plugin.name else plugin) plugins;
in
{
  home.packages = with pkgs; [
    # Neovim utils
    fd
    bat
    ripgrep

    # Tree-sitter requirements
    go
    nodejs

    # Language servers
    vtsls
    marksman
    helm-ls
    gopls
    sqls
    rustup
    lua-language-server
    copilot-node-server
    vscode-json-languageserver
    nodePackages.yaml-language-server
  ];

  programs.neovim = {
    enable = true;
    extraLuaConfig =
      (lib.concatStringsSep "\n" (
        map (plugin: "require('${plugin.pluginName}').setup ${plugin.setup}") pluginsToSetup
      ))
      + "\n" + (builtins.readFile (pkgs.replaceVars ./neovim/init.lua {
        sqls = "${pkgs.sqls}";
        gopls = "${pkgs.gopls}";
        vtsls = "${pkgs.vtsls}";
        rustup = "${pkgs.rustup}";
        helm-ls = "${pkgs.helm-ls}";
        marksman = "${pkgs.marksman}";
        copilot-node-server = "${pkgs.copilot-node-server}";
        lua-language-server = "${pkgs.lua-language-server}";
        vscode-json-languageserver = "${pkgs.vscode-json-languageserver}";
        yaml-language-server = "${pkgs.nodePackages.yaml-language-server}";
      }));
    plugins =
      with pkgs.vimPlugins;
      map (name: pkgs.vimPlugins.${name}) pluginNames
      ++ [kubectl-nvim]
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
        javascript
        typescript
        yaml
        xml
        toml
        json
        nix
      ]);
  };
}
