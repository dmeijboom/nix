{
  lib,
  config,
  pkgs,
  ...
}:
let
  vimPluginName = (
    name: lib.strings.replaceString ".lua" "" (lib.strings.replaceString ".nvim" "" name)
  );
  plugins = {
    mini-surround = { };
    mini-comment = { };
    mini-icons = { };
    auto-save-nvim = { };
    nvim-tree-lua = { };
    telescope-nvim = { };
  };
  pluginNames = lib.mapAttrsToList (
    name: config: vimPluginName pkgs.vimPlugins.${name}.pname
  ) plugins;
in
{
  home.packages = with pkgs; [
    fd
    bat
    vtsls
    ripgrep
  ];

  programs.neovim = {
    enable = true;
    extraLuaConfig = ''
      -- Utilities
      local terminal_buf = -1
      local terminal_win = -1

      local function toggle_terminal()
        if terminal_win ~= -1 and vim.fn.win_id2win(terminal_win) ~= 0 then
          vim.cmd(vim.fn.win_id2win(terminal_win) .. 'close')
          terminal_win = -1
        else
          vim.cmd('botright split')
          vim.cmd('resize 15')

          if terminal_buf ~= -1 and vim.fn.bufexists(terminal_buf) == 1 then
            vim.cmd('buffer ' .. terminal_buf)
          else
            vim.cmd('terminal')
            terminal_buf = vim.fn.bufnr('%')
          end

          terminal_win = vim.fn.win_getid()
          vim.cmd('startinsert')
        end
      end

      -- Language servers
      local cmp = require'cmp'

      cmp.setup {
        sources = {
          { name = 'nvim_lsp' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        performance = {
          max_view_entries = 25,
        },
        experimental = {
          ghost_text = true,
        },
      }

      -- Completions
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      vim.lsp.config('vtsls', {
        capabilities = capabilities,
        cmd = { '${pkgs.vtsls}/bin/vtsls', '--stdio' },
        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' },
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = 'all' },
            }
          },
          javascript = {
            inlayHints = {
              parameterNames = { enabled = 'all' },
            }
          }
        },
      })

      vim.lsp.enable('vtsls')
      vim.lsp.inlay_hint.enable()

      -- Settings
      vim.g.nord_italic = false
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.opt.hlsearch = false
      vim.opt.showmode = false
      vim.opt.laststatus = 0
      vim.opt.termguicolors = true
      vim.opt.relativenumber = true
      vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}

      local colors = require('nord.colors')
      local nordUtil = require('nord.util')

      nordUtil.highlight('LspInlayHint', { fg = colors.nord3_gui_bright })
      nordUtil.highlight('WinSeparator', { fg = colors.nord1_gui })

      -- Leader key
      vim.g.mapleader = ','

      -- Keybindings
      local keymap = vim.keymap.set

      -- Terminal escape
      keymap('t', '<Esc>', '<C-\\><C-n>')

      -- File operations
      keymap('n', '<C-p>', ':Telescope find_files find_command=rg,--ignore,--hidden,--files<CR>')
      keymap('n', '<leader>f', ':NvimTreeFindFileToggle<CR>')
      keymap('n', '<C-f>', ':NvimTreeFindFileToggle<CR>')

      -- Terminal toggle
      keymap('n', '<leader>t', toggle_terminal)
      keymap('n', '<C-t>', toggle_terminal)

      -- Window navigation
      keymap('n', '<leader>wh', '<C-w>h')
      keymap('n', '<leader>wj', '<C-w>j')
      keymap('n', '<leader>wk', '<C-w>k')
      keymap('n', '<leader>wl', '<C-w>l')

      -- Language server
      keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
      keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })

      require('nord').set()
      vim.cmd([[colorscheme nord]])
    ''
    + (lib.concatStringsSep "\n" (map (name: "require('${name}').setup {}") pluginNames));
    plugins =
      with pkgs.vimPlugins;
      [
        # Completion
        nvim-treesitter
        nvim-lspconfig
        cmp-nvim-lsp
        nvim-cmp

        # Theme
        nord-nvim
      ]
      ++ lib.mapAttrsToList (name: _: pkgs.vimPlugins.${name}) plugins
      ++ (with pkgs.vimPlugins.nvim-treesitter-parsers; [
        bash
        c
        html
        markdown
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
