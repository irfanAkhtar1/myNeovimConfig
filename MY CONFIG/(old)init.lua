-- =============================================================================
--  irfan's neovim config (kickstart base)
--  github: irfanAkhtar1
-- =============================================================================

-- ─── Leader ──────────────────────────────────────────────────────────────────
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

-- ─── Globals ─────────────────────────────────────────────────────────────────
vim.g.have_nerd_font = true

vim.fn.chdir('D:/Desktop')

-- ─── Options ─────────────────────────────────────────────────────────────────
local o   = vim.o
local opt = vim.opt

o.number         = true
o.relativenumber = true
o.mouse          = 'a'
o.showmode       = false
o.breakindent    = true
o.undofile       = true
o.ignorecase     = true
o.smartcase      = true
o.signcolumn     = 'yes'
o.updatetime     = 250
o.timeoutlen     = 300
o.splitright     = true
o.splitbelow     = true
o.inccommand     = 'split'
o.cursorline     = true
o.scrolloff      = 10
o.confirm        = false
o.emoji          = true
o.list           = true
o.expandtab      = true
o.tabstop        = 4
o.shiftwidth     = 4
o.softtabstop    = 4

opt.encoding     = 'utf-8'
opt.fileencoding = 'utf-8'
opt.listchars    = { tab = '» ', trail = '·', nbsp = '␣' }

vim.schedule(function() o.clipboard = 'unnamedplus' end)

-- ─── Transparent Background ──────────────────────────────────────────────────
local function set_transparent()
  local groups = {
    'Normal', 'NormalNC', 'NormalFloat', 'FloatBorder',
    'NeoTreeNormal', 'NeoTreeNormalNC', 'SignColumn',
  }
  for _, g in ipairs(groups) do
    vim.api.nvim_set_hl(0, g, { bg = 'none' })
  end
end

set_transparent()


-- ─── Keymaps ─────────────────────────────────────────────────────────────────

vim.keymap.set('n', '<leader>r', ':browse oldfiles<CR>', { desc = 'Open recent files' })


local map = vim.keymap.set

-- Save
map('i', '<C-s>', '<Esc>:w<CR>',  { desc = 'Exit insert and save' })
map('n', '<C-s>', ':w<CR>',        { desc = 'Save file' })

-- File tree
map('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle [E]xplorer' })

-- Config shortcuts
map('n', '<leader>cc', function()
  require('telescope.builtin').find_files { cwd = 'C:/Users/Irfan Akhtar/AppData/Local/nvim' }
end, { desc = 'Open [C]onfig files' })

map('n', '<leader>ci', function()
  vim.cmd('edit C:/Users/Irfan Akhtar/AppData/Local/nvim/init.lua')
end, { desc = 'Open [C]onfig [I]nit' })

map('n', '<leader>cd', function()
  vim.cmd('cd %:p:h')
  print('cwd: ' .. vim.fn.getcwd())
end, { desc = '[C]hange [D]irectory to current file' })

-- Stay in visual mode after indent
map('v', '<', '<gv', { desc = 'Indent left (stay in visual)' })
map('v', '>', '>gv', { desc = 'Indent right (stay in visual)' })

-- Buffer navigation
map('n', '<S-h>',      ':BufferLineCyclePrev<CR>', { desc = 'Prev buffer' })
map('n', '<S-l>',      ':BufferLineCycleNext<CR>', { desc = 'Next buffer' })
map('n', '<leader>x',  ':bd<CR>',                  { desc = 'Close buffer' })
map('n', '<leader>bl', ':BufferLineMoveNext<CR>',   { desc = 'Move buffer right' })
map('n', '<leader>bh', ':BufferLineMovePrev<CR>',   { desc = 'Move buffer left' })
map('n', 'zz',         ':bd!<CR>',                  { desc = 'Force close buffer' })

-- Misc
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Diagnostics
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Window navigation
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper window' })

-- Terminal
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- F5 runner
map('n', '<F5>', function()
  local ft   = vim.bo.filetype
  local file = vim.fn.expand('%:p')

  if     ft == 'python'     then vim.cmd('term python "'      .. file .. '"')
  elseif ft == 'javascript' then vim.cmd('term node "'        .. file .. '"')
  elseif ft == 'typescript' then vim.cmd('term npx ts-node "' .. file .. '"')
  elseif ft == 'c'          then vim.cmd('term gcc "'         .. file .. '" -o out && out')
  elseif ft == 'cpp'        then
    local name = vim.fn.expand('%:t:r')
    local dir  = vim.fn.expand('%:p:h')
    vim.cmd('term g++ "' .. file .. '" -o "' .. dir .. '/' .. name .. '" && "' .. dir .. '/' .. name .. '"')
  elseif ft == 'lua'        then vim.cmd('term "D:/Lua/Bin/lua.exe" "' .. file .. '"')
  elseif ft == 'cs'         then vim.cmd('term dotnet run')
  else print('No runner for filetype: ' .. ft)
  end
end, { desc = 'Run current file' })

-- ─── Diagnostics Config ──────────────────────────────────────────────────────
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort    = true,
  float            = { border = 'rounded', source = 'if_many' },
  underline        = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text     = true,
  virtual_lines    = false,
  jump             = { float = true },
}

-- ─── Autocommands ────────────────────────────────────────────────────────────

-- Colorscheme + transparent bg on enter
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.cmd.colorscheme 'gruvbox'
    set_transparent()
  end,
})

-- Yank highlight
vim.api.nvim_create_autocmd('TextYankPost', {
  desc     = 'Highlight on yank',
  group    = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- ─── Lazy Bootstrap ──────────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system {
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end
vim.opt.rtp:prepend(lazypath)

-- ─── Plugins ─────────────────────────────────────────────────────────────────
require('lazy').setup({

  { 'NMAC427/guess-indent.nvim', opts = {} },

  -- Git signs
  {
    'lewis6991/gitsigns.nvim',
    ---@type Gitsigns.Config
    opts = {
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Which-key
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@type wk.Opts
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec  = {
        { '<leader>s', group = '[S]earch',   mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { 'gr',        group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    enabled      = true,
    event        = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond  = function() return vim.fn.executable('make') == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local b = require('telescope.builtin')

      vim.keymap.set('n', '<leader>sh',        b.help_tags,    { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk',        b.keymaps,      { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf',        b.find_files,   { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss',        b.builtin,      { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set({ 'n', 'v' }, '<leader>sw', b.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg',        b.live_grep,    { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd',        b.diagnostics,  { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr',        b.resume,       { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.',        b.oldfiles,     { desc = '[S]earch Recent Files' })
      vim.keymap.set('n', '<leader>sc',        b.commands,     { desc = '[S]earch [C]ommands' })
      vim.keymap.set('n', '<leader><leader>',  b.buffers,      { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        b.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend  = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzy search current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        b.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        b.find_files { cwd = vim.fn.stdpath('config') }
      end, { desc = '[S]earch [N]eovim files' })

      -- Telescope LSP pickers (attached per buffer)
      vim.api.nvim_create_autocmd('LspAttach', {
        group    = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf
          vim.keymap.set('n', 'grr', b.lsp_references,              { buffer = buf, desc = '[G]oto [R]eferences' })
          vim.keymap.set('n', 'gri', b.lsp_implementations,         { buffer = buf, desc = '[G]oto [I]mplementation' })
          vim.keymap.set('n', 'grd', b.lsp_definitions,             { buffer = buf, desc = '[G]oto [D]efinition' })
          vim.keymap.set('n', 'gO',  b.lsp_document_symbols,        { buffer = buf, desc = 'Open Document Symbols' })
          vim.keymap.set('n', 'gW',  b.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
          vim.keymap.set('n', 'grt', b.lsp_type_definitions,        { buffer = buf, desc = '[G]oto [T]ype Definition' })
        end,
      })
    end,
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim',              opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim',                 opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group    = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local lmap = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          lmap('grn',  vim.lsp.buf.rename,       '[R]e[n]ame')
          lmap('gra',  vim.lsp.buf.code_action,  '[G]oto Code [A]ction', { 'n', 'x' })
          lmap('grD',  vim.lsp.buf.declaration,  '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local hl_group = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer   = event.buf,
              group    = hl_group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer   = event.buf,
              group    = hl_group,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group    = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(e2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = e2.buf }
              end,
            })
          end

          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            lmap('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local servers = {
        omnisharp = {},
        pyright   = {},
        html      = {},
        cssls     = {},
        ts_ls     = {},
        emmet_ls  = {

          filetypes = {

            'html', 'css', 
            'javascript', 'typescriptreact',
            

          }

        },
        lua_ls    = {
          on_init = function(client)
            client.server_capabilities.documentFormattingProvider = false
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
              then return end
            end
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime   = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
              workspace = {
                checkThirdParty = false,
                library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                  '${3rd}/luv/library',
                  '${3rd}/busted/library',
                }),
              },
            })
          end,
          settings = { Lua = { format = { enable = false } } },
        },
        stylua    = {},
      }

      require('mason-tool-installer').setup { ensure_installed = vim.tbl_keys(servers) }

      for name, server in pairs(servers) do
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },

  -- Autoformat
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd   = { 'ConformInfo' },
    keys  = {
      {
        '<leader>f',
        function() require('conform').format { async = true } end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error  = false,
      format_on_save   = function(bufnr)
        local enabled = { --[[ lua = true, python = true ]] }
        if enabled[vim.bo[bufnr].filetype] then
          return { timeout_ms = 500 }
        end
      end,
      default_format_opts = { lsp_format = 'fallback' },
      formatters_by_ft    = {
        cpp = { 'clang-format' },
        c   = { 'clang-format' },
      },
      formatters = {
        ['clang-format'] = {
          command = vim.fn.stdpath('data') .. '/mason/bin/clang-format.CMD',
        },
      },
    },
  },

-- Autocompletion
{
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-n>']     = cmp.mapping.select_next_item(),
        ['<C-p>']     = cmp.mapping.select_prev_item(),
        ['<C-y>']     = cmp.mapping.confirm { select = true },
        ['<CR>']      = cmp.mapping.confirm { select = true },
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<Tab>']     = cmp.mapping(function(fallback)
          if cmp.visible() then cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
          else fallback() end
        end, { 'i', 's' }),
      },
      sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      },
    }

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
    })
  end,
},

----indentation for c++

  -- Colorscheme (tokyonight loaded for fallback; gruvbox set on VimEnter)
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config   = function()
      require('tokyonight').setup {
        styles = { comments = { italic = false } },
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- TODO comments
  {
    'folke/todo-comments.nvim',
    event        = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts         = { signs = false },
  },

  -- Mini
  {
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.icons').setup()
      MiniIcons.mock_nvim_web_devicons()

      require('mini.ai').setup {
        mappings = { around_next = 'aa', inside_next = 'ii' },
        n_lines  = 500,
      }

      require('mini.surround').setup()

      local statusline = require('mini.statusline')
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    lazy   = false,
    build  = ':TSUpdate',
    branch = 'main',
    config = function()
      local base_parsers = {
        'bash', 'c', 'diff', 'html', 'lua', 'luadoc',
        'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc',
      }
      require('nvim-treesitter').install(base_parsers)

      local function try_attach(buf, lang)
        if not vim.treesitter.language.add(lang) then return end
        vim.treesitter.start(buf, lang)
        if vim.treesitter.query.get(lang, 'indents') then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      local available = require('nvim-treesitter').get_available()

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then return end
          local installed = require('nvim-treesitter').get_installed('parsers')
          if vim.tbl_contains(installed, lang) then
            try_attach(args.buf, lang)
          elseif vim.tbl_contains(available, lang) then
            require('nvim-treesitter').install(lang):await(function()
              try_attach(args.buf, lang)
            end)
          else
            try_attach(args.buf, lang)
          end
        end,
      })
    end,
  },

  -- Extra plugins
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',

  { import = 'custom.plugins' },

}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂',
      init = '⚙', keys = '🗝', plugin = '🔌', runtime = '💻',
      require = '🌙', source = '📄', start = '🚀', task = '📌', lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
