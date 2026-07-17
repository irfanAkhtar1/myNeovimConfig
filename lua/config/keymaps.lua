local map = vim.keymap.set

map('n', '<leader>r', ':browse oldfiles<CR>', { desc = 'Open recent files' })

-- Save
map('i', '<C-s>', '<Esc>:w<CR>', { desc = 'Exit insert and save' })
map('n', '<C-s>', ':w<CR>',      { desc = 'Save file' })

-- File tree
map('n', '<leader>e', ':Neotree toggle position=right<CR>', { desc = 'Toggle [E]xplorer' })
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
map('n', '<S-h>',     ':BufferLineCyclePrev<CR>', { desc = 'Prev buffer' })
map('n', '<S-l>',     ':BufferLineCycleNext<CR>', { desc = 'Next buffer' })
map('n', '<leader>x', ':bd<CR>',                  { desc = 'Close buffer' })
map('n', '<leader>bl', ':BufferLineMoveNext<CR>',  { desc = 'Move buffer right' })
map('n', '<leader>bh', ':BufferLineMovePrev<CR>',  { desc = 'Move buffer left' })
map('n', 'zz',         ':bd!<CR>',                 { desc = 'Force close buffer' })

-- Misc
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Diagnostics
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Window navigation
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper window' })


-- Love 2D 
map('n', '<leader>vr', function()
  vim.cmd('term love .')
end, { desc = '[R]un love . (no project check)' })

-- Terminal
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- MinGW terminal


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
