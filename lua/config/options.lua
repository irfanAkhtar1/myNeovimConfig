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
