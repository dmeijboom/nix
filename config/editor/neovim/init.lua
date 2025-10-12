vim.loader.enable()

-- Event handling
local prompt = nil
local zellij_enabled = true

local zellij_pipe = function(name, result)
  if not zellij_enabled then
    return
  end

  vim.system(
    { 'zellij', 'pipe', 'zjstatus::pipe::pipe_' .. name .. '::' .. vim.trim(result) },
    { text = true }
  )
end

local zellij_sync = function()
  local result = vim.api.nvim_eval_statusline(
    '%t %l:%c%{reg_recording()!=""?" [REC]":""}%r',
    { highlights = true }
  )

  local divider = '\27[38;2;129;161;193m›\27[0m'
  local ghost_text = '\27[38;2;97;110;136m' .. result.str .. '\27[0m'

  if prompt then
    zellij_pipe('status', prompt .. divider .. ' ' .. ghost_text)
  else
    zellij_pipe('status', ghost_text)
  end
end

vim.api.nvim_create_autocmd('ExitPre', {
  callback = function()
    local dirname = vim.fs.basename(vim.fn.getcwd())
    vim.cmd('mks! /tmp/.session_' .. dirname)

    zellij_pipe('status', '')
  end
})

vim.api.nvim_create_autocmd('FocusGained', {
  callback = function()
    zellij_enabled = true
    zellij_sync()
  end
})

vim.api.nvim_create_autocmd('FocusLost', {
  callback = function()
    zellij_pipe('status', '')
    zellij_enabled = false
  end
})

local update_prompt = function()
  local cwd = vim.fn.getcwd()
  local dirname = vim.fs.basename(cwd)

  vim.cmd('silent !zellij action rename-tab "' .. dirname .. '"')
  vim.system(
    { 'zsh', '-c', 'starship prompt --profile zellij --path "' ..
    cwd .. '" --terminal-width 80 | sed "s/%{//g; s/%}//g"' }, { text = true }, function(result)
      if result.code == 0 then
        prompt = result.stdout
      else
        prompt = nil
      end
    end)
end

vim.api.nvim_create_autocmd('User', {
  pattern = { 'NeogitStatusRefreshed', 'NeogitCommitComplete', 'NeogitPushComplete', 'NeogitPullComplete', 'NeogitBranchCheckout' },
  callback = update_prompt,
})

vim.api.nvim_create_autocmd({ 'UIEnter', 'DirChanged' }, {
  callback = update_prompt,
})

local timer = nil

vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'WinEnter', 'BufEnter' }, {
  callback = function()
    if timer then
      timer:stop()
      timer:close()
    end

    timer = vim.loop.new_timer()
    timer:start(400, 0, vim.schedule_wrap(function()
      zellij_sync()
    end))
  end
})

-- Rest nvim
vim.g.rest_nvim = {
  request = {
    skip_ssl_verification = true,
  },
}

-- Language servers
local capabilities = require('blink.cmp').get_lsp_capabilities()

vim.lsp.config('buf_ls', {
  capabilities = capabilities,
  cmd = { '@buf@/bin/buf', 'beta', 'lsp', '--timeout=0', '--log-format=text' },
})

vim.lsp.config('mdx_analyzer', {
  capabilities = capabilities,
  cmd = { '@mdx-language-server@/bin/mdx-language-server', '--stdio' },
})

vim.lsp.config('prismals', {
  capabilities = capabilities,
  cmd = { '@prisma-language-server@/bin/prisma-language-server', '--stdio' },
})

vim.lsp.config('emmet_language_server', {
  capabilities = capabilities,
  cmd = { '@emmet-language-server@/bin/emmet-language-server', '--stdio' },
  init_options = {
    showSuggestionsAsSnippets = true,
  },
})

vim.lsp.config('bashls', {
  capabilities = capabilities,
  cmd = { '@bash-language-server@/bin/bash-language-server', 'start' },
})

vim.lsp.config('basedpyright', {
  capabilities = capabilities,
  cmd = { '@basedpyright@/bin/basedpyright-langserver', '--stdio' },
  settings = {
    basedpyright = {
      analysis = {
        ignore = { '*' },
        typeCheckingMode = 'basic',
        disableOrganizeImports = true,
      }
    }
  }
})

vim.lsp.config('ruff', {
  capabilities = capabilities,
  cmd = { '@ruff@/bin/ruff', 'server' },
  on_attach = function(client, bufnr)
    client.server_capabilities.hoverProvider = false
  end,
  init_options = {
    settings = {
      lint = {
        preview = true,
      },
    },
  },
})

vim.lsp.config('dockerls', {
  capabilities = capabilities,
  cmd = { '@dockerfile-language-server@/bin/docker-langserver', '--stdio' },
})

vim.lsp.config('eslint', {
  capabilities = capabilities,
  cmd = { '@vscode-langservers-extracted@/bin/vscode-eslint-language-server', '--stdio' },
})

vim.lsp.config('nil', {
  capabilities = capabilities,
  cmd = { '@nil@/bin/nil' },
})

vim.lsp.config('denols', {
  capabilities = capabilities,
  cmd = { '@deno@/bin/deno', 'lsp' },
  settings = {
    inlayHints = {
      parameterNames = { enabled = 'all' },
    },
  },
})

vim.lsp.config('tailwindcss', {
  capabilities = capabilities,
  cmd = { '@tailwindcss-language-server@/bin/tailwindcss-language-server', '--stdio' },
})

vim.lsp.config('jsonls', {
  capabilities = capabilities,
  cmd = { '@vscode-langservers-extracted@/bin/vscode-json-language-server', '--stdio' },
})

vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  cmd = { '@lua-language-server@/bin/lua-language-server' },
})

vim.lsp.config('tombi', {
  capabilities = capabilities,
  cmd = { '@tombi@/bin/tombi', 'lsp' },
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

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = '@vue-language-server@/lib/language-tools/packages/language-server',
  languages = { 'vue' },
  configNamespace = 'typescript',
}

vim.lsp.config('vue_ls', {
  capabilities = capabilities,
  cmd = { '@vue-language-server@/bin/vue-language-server', '--stdio' },
})

vim.lsp.config('vtsls', {
  capabilities = capabilities,
  cmd = { '@vtsls@/bin/vtsls', '--stdio' },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
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

vim.lsp.enable('sqls')
vim.lsp.enable('prismals')
vim.lsp.enable('tombi')
vim.lsp.enable('vue_ls')
vim.lsp.enable('vtsls')
vim.lsp.enable('denols')
vim.lsp.enable('tailwindcss')
-- vim.lsp.enable('nil') @TODO: horrible..
vim.lsp.enable('eslint')
vim.lsp.enable('dockerls')
vim.lsp.enable('bashls')
vim.lsp.enable('ruff')
vim.lsp.enable('basedpyright')
vim.lsp.enable('marksman')
vim.lsp.enable('lua_ls')
vim.lsp.enable('jsonls')
vim.lsp.enable('gopls')
vim.lsp.enable('yamlls')
vim.lsp.enable('helm_ls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('emmet_language_server')
vim.lsp.enable('mdx_analyzer')
vim.lsp.enable('buf_ls')
vim.lsp.inlay_hint.enable()

-- Settings
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.signcolumn = 'yes'
vim.opt.swapfile = false
vim.opt.hlsearch = false
vim.opt.showmode = false
vim.opt.laststatus = 0
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.opt.shortmess:append('I')
vim.opt.cmdheight = 0
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.iskeyword:append('-')
vim.opt.iskeyword:append('_')

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

-- CodeCompanion
keymap({ "n", "v" }, "<leader>c", "<cmd>CodeCompanionChat Toggle<cr>", extra("Toggle chat"))
keymap("v", "ga", "<cmd>CodeCompanionChat Add<cr>", extra("Add context"))

-- Rest operations
keymap('n', '<leader>R', ':Rest run<CR>', extra('REST Run'))

-- Telescope operations
keymap('n', '<leader>b', ':Telescope buffers theme=dropdown previewer=false prompt_title=false<CR>',
  extra("Show buffers"))
keymap('n', '<leader>t', function()
  vim.ui.select(vim.fn.systemlist('zellij action query-tab-names'), {
    prompt = 'Select tab:',
  }, function(name)
    if name then
      vim.cmd('silent !zellij action go-to-tab-name "' .. name .. '"')
    end
  end)
end, extra("Show tabs"))

-- File operations
keymap('n', '<C-p>',
  ':Telescope find_files theme=dropdown previewer=false prompt_title=false find_command=rg,--ignore,--files<CR>', quiet)
keymap('n', '<C-f>', ':NvimTreeFindFileToggle<CR>', quiet)
keymap('n', '<leader>p', function()
  require('telescope').extensions.project.project(require('telescope.themes').get_dropdown({
    prompt_title = false,
  }))
end, quiet)
keymap('n', '<leader>ff', ':Telescope live_grep prompt_title=false preview_title=false theme=ivy<CR>',
  extra('Find in files'))
keymap('n', '<leader>fs', ':Telescope lsp_document_symbols prompt_title=false theme=dropdown previewer=false<CR>',
  extra('Show symbols'))
keymap('n', '<leader>fw', function()
  require('telescope.builtin').live_grep(require('telescope.themes').get_cursor({
    default_text = vim.fn.expand('<cword>')
  }))
end, extra('Find selected word'))

-- Git operations
keymap('n', '<leader>gb', ':Telescope git_branches prompt_title=false<CR>', extra('Git branches'))
keymap('n', '<leader>gs', ':Neogit<CR>', extra('Git status'))
keymap('n', '<leader>gl', ':NeogitLogCurrent<CR>', extra('Git log'))
keymap('n', '<leader>gd', ':Gitsigns preview_hunk<CR>', extra('Git diff (line)'))

-- Github operations
keymap('n', '<leader>hp', ':Telescope gh pull_request<CR>', extra('Github PRs'))

-- Overseer toggle
keymap('n', '<C-t>', ':OverseerToggle<CR>', quiet)
keymap('n', '<leader>x', ':OverseerRun<CR>', extra('Run task'))

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
keymap('n', '<leader>en', '<cmd>lua vim.diagnostic.goto_next()<CR>', extra('Next error'))
keymap('n', '<leader>eN', '<cmd>lua vim.diagnostic.goto_prev()<CR>', extra('Previous error'))

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
  { "<leader>h", group = "github" },
  { "<leader>e", group = "errors" },
})

-- Setup custom plugins
require 'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["ai"] = "@parameter.inner",
        ["aa"] = "@parameter.outer",
      },
    }
  }
}

-- Misc
local telescope = require('telescope')

telescope.load_extension('ui-select')
telescope.load_extension('gh')

vim.diagnostic.config({
  virtual_text = false,
  signs = false,
  underline = true,
})

vim.cmd.colorscheme 'nord'

-- Theme highlight fixes
vim.api.nvim_set_hl(0, 'Special', { fg = '#8FBCBB' })
vim.api.nvim_set_hl(0, 'htmlTag', { fg = '#81A1C1' })
vim.api.nvim_set_hl(0, 'htmlTagName', { fg = '#81A1C1' })
vim.api.nvim_set_hl(0, 'Type', { fg = '#8FBCBB' })
vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = '#4c6d9b' })
vim.api.nvim_set_hl(0, 'IndentLine', { fg = '#383E4C' })
vim.api.nvim_set_hl(0, 'IndentLineCurrent', { fg = '#404859' })
vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = '#434C5E' })
vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = '#434C5E' })
vim.api.nvim_set_hl(0, 'GitSignsAddPreview', { bg = '#3b4252', fg = '#a3be8c' })
vim.api.nvim_set_hl(0, 'GitSignsDeletePreview', { bg = '#3b4252', fg = '#bf616a' })
vim.api.nvim_set_hl(0, 'GitSignsAddInline', { bg = '#a3be8c', fg = '#2e3440' })
vim.api.nvim_set_hl(0, 'GitSignsDeleteInline', { bg = '#bf616a', fg = '#2e3440' })
vim.api.nvim_set_hl(0, 'GitSignsChangeInline', { bg = '#ebcb8b', fg = '#2e3440' })
vim.api.nvim_set_hl(0, 'GitSignsDeleteVirtLn', { bg = '#3b4252', fg = '#bf616a' })

vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', {
  undercurl = true,
  sp = '#BF616A'
})

vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', {
  undercurl = true,
  sp = '#EBCB8B'
})

vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', {
  undercurl = true,
  sp = '#88C0D0'
})

vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', {
  undercurl = true,
  sp = '#A3BE8C'
})
