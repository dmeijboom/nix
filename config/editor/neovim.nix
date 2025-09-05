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

  gitsigns-nvim = mkPlugin "gitsigns-nvim" { name = "gitsigns"; };
  nvim-web-devicons = mkPlugin "nvim-web-devicons" { name = "nvim-web-devicons"; };
  nvim-surround = mkPlugin "nvim-surround" { name = "nvim-surround"; };
  mini-icons = mkPlugin "mini-icons" { name = "mini.icons"; };
  auto-save-nvim = mkPlugin "auto-save-nvim" { name = "auto-save"; };
  copilot-cmp = mkPlugin "copilot-cmp" { name = "copilot_cmp"; };
  copilot-lua = mkPlugin "copilot-lua" {
    name = "copilot";
    copilot_node_command = "${pkgs.nodejs}/bin/node";
    suggestion = {
      enabled = true;
    };
    panel = {
      enabled = false;
    };
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
  cmp-nvim-lsp = mkPlugin "cmp-nvim-lsp" { name = "cmp_nvim_lsp"; };

  plugins = [
    "nvim-treesitter"
    "nvim-lspconfig"
    "nvim-cmp"
    "vim-illuminate"
    "telescope-ui-select-nvim"
    "indent-blankline-nvim-lua"
    cmp-nvim-lsp
    copilot-lua
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
    gopls
    lua-language-server
    copilot-node-server
  ];

  programs.neovim = {
    enable = true;
    extraLuaConfig =
      (lib.concatStringsSep "\n" (
        map (plugin: "require('${plugin.pluginName}').setup ${plugin.setup}") pluginsToSetup
      ))
      + "\n" + (builtins.readFile (pkgs.replaceVars ./neovim/init.lua {
        copilot-node-server = "${pkgs.copilot-node-server}";
        lua-language-server = "${pkgs.lua-language-server}";
        gopls = "${pkgs.gopls}";
        marksman = "${pkgs.marksman}";
        vtsls = "${pkgs.vtsls}";
      }));
    plugins =
      with pkgs.vimPlugins;
      map (name: pkgs.vimPlugins.${name}) pluginNames
      ++ (with pkgs.vimPlugins.nvim-treesitter-parsers; [
        bash
        c
        go
        html
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
