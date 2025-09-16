vim.loader.enable()

-- Session Management
vim.api.nvim_create_autocmd('ExitPre', {
  callback = function()
    local dirname = vim.fs.basename(vim.fn.getcwd())
    vim.cmd('mks! /tmp/.session_' .. dirname)
  end
})

-- Utilities
local terminal_buf = -1
local terminal_win = -1

function close_terminal()
  if terminal_win ~= -1 and vim.fn.win_id2win(terminal_win) ~= 0 then
    vim.cmd(vim.fn.win_id2win(terminal_win) .. 'close')
    terminal_win = -1
  end
end

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
      vim.cmd('terminal zsh')
      terminal_buf = vim.fn.bufnr('%')
    end

    terminal_win = vim.fn.win_getid()
    vim.cmd('startinsert')
  end
end

-- Rest nvim
vim.g.rest_nvim = {
  request = {
    skip_ssl_verification = true,
  },
}

-- Language servers
local capabilities = require('blink.cmp').get_lsp_capabilities()

vim.lsp.config('copilot', {
  capabilities = capabilities,
  cmd = { '@copilot-node-server@/bin/copilot-node-server', '--stdio' },
})

vim.lsp.config('jsonls', {
  capabilities = capabilities,
  cmd = { '@vscode-json-languageserver@/bin/vscode-json-language-server', '--stdio' },
})

vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  cmd = { '@lua-language-server@/bin/lua-language-server' },
})

vim.lsp.config('sqls', {
  capabilities = capabilities,
  cmd = { '@sqls@/bin/sqls' },
})

vim.lsp.config('rust_analyzer', {
  capabilities = capabilities,
  cmd = { '@rustup@/bin/rust-analyzer' },
  settings = {
    ["rust-analyzer"] = {
      inlayHints = {
        typeHints = {
          enable = true,
        },
      },
    },
  },
})

vim.lsp.config('gopls', {
  capabilities = capabilities,
  cmd = { '@gopls@/bin/gopls' },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
      ["ui.inlayhint.hints"] = {
        compositeLiteralFields = true,
        constantValues = true,
        parameterNames = true
      },
    },
  },
})

vim.lsp.config('yamlls', {
  capabilities = capabilities,
  cmd = { '@yaml-language-server@/bin/yaml-language-server', '--stdio' },
})

vim.lsp.config('marksman', {
  capabilities = capabilities,
  cmd = { '@marksman@/bin/marksman', 'server' },
})

vim.lsp.config('vtsls', {
  capabilities = capabilities,
  cmd = { '@vtsls@/bin/vtsls', '--stdio' },
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

vim.lsp.config('helm_ls', {
  capabilities = capabilities,
  cmd = { '@helm-ls@/bin/helm_ls', 'serve' },
})

require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

vim.lsp.enable('sqls')
vim.lsp.enable('vtsls')
vim.lsp.enable('copilot')
vim.lsp.enable('marksman')
vim.lsp.enable('lua_ls')
vim.lsp.enable('jsonls')
vim.lsp.enable('gopls')
vim.lsp.enable('yamlls')
vim.lsp.enable('helm_ls')
vim.lsp.enable('rust_analyzer')
vim.lsp.inlay_hint.enable()

-- Settings
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.signcolumn = 'yes'
vim.opt.hlsearch = false
vim.opt.showmode = false
vim.opt.laststatus = 0
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.opt.shortmess:append('I')
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.clipboard = 'unnamedplus'

-- Leader key
vim.g.mapleader = ','

-- Keybindings
local keymap = vim.keymap.set
local quiet = { noremap = true, silent = true }
local extra = function(desc)
  return { noremap = true, silent = true, desc = desc }
end

-- Terminal escape
keymap('t', '<Esc>', '<C-\\><C-n>')

-- Quickfix
keymap('n', '<leader>q', function()
  require("quicker").toggle()
end, extra('Toggle quickfix'))

-- File operations
keymap('n', '<C-p>', ':Telescope find_files theme=dropdown previewer=false find_command=rg,--ignore,--files<CR>', quiet)
keymap('n', '<C-f>', ':NvimTreeFindFileToggle<CR>', quiet)
keymap('n', '<leader>p', function()
  require('telescope').extensions.project.project(require('telescope.themes').get_dropdown({}))
end, quiet)
keymap('n', '<leader>ff', ':Telescope live_grep<CR>', extra('Find in files'))
keymap('n', '<leader>fs', ':Telescope lsp_document_symbols theme=dropdown<CR>', extra('Show symbols'))
keymap('n', '<leader>fw', function()
  require('telescope.builtin').live_grep(require('telescope.themes').get_cursor({
    default_text = vim.fn.expand('<cword>')
  }))
end, extra('Find selected word'))

-- Git operations
keymap('n', '<leader>gb', ':Telescope git_branches<CR>', extra('Git branches'))
keymap('n', '<leader>gs', ':Neogit<CR>', extra('Git status'))
keymap('n', '<leader>gl', ':NeogitLogCurrent<CR>', extra('Git log'))

-- Terminal toggle
keymap('n', '<C-t>', toggle_terminal, quiet)
keymap('t', '<C-t>', toggle_terminal, quiet)

-- Window navigation
keymap('n', '<leader>wh', '<C-w>h', quiet)
keymap('n', '<leader>wj', '<C-w>j', quiet)
keymap('n', '<leader>wk', '<C-w>k', quiet)
keymap('n', '<leader>wl', '<C-w>l', quiet)
keymap('n', '<leader>w/', ':vsplit<CR><C-w>l', quiet)
keymap('n', '<leader>w-', ':split<CR><C-w>j', quiet)

-- Kubernetes
keymap('n', '<leader>k', '<cmd>lua require("kubectl").toggle({ tab = false })<CR>', quiet)

-- Language server
keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', quiet)
keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', quiet)
keymap('n', '<leader>f=', '<cmd>lua vim.lsp.buf.format()<CR>', extra('Format document'))
keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', extra('Refactor rename'))
keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', extra('Code actions'))

vim.api.nvim_command(
  'autocmd BufRead,BufNewFile */templates/*.yaml,*/templates/*.tpl,*.gotmpl,helmfile*.yaml set ft=helm')

-- Diagnostics
keymap('n', '<leader>d', ':Trouble diagnostics toggle<CR>', extra('Toggle diagnostics'))

vim.diagnostic.config({
  signs = false,
  virtual_text = {
    severity = { min = vim.diagnostic.severity.ERROR },
  },
})

-- Which key
local wk = require('which-key')
wk.add({
  { "<leader>f", group = "file" },
  { "<leader>w", group = "window" },
  { "<leader>g", group = "git" },
})

-- Misc
require('kubectl').setup()
require('telescope').load_extension('ui-select')

vim.cmd.colorscheme 'nord'
