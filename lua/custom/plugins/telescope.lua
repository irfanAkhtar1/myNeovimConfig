return {
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
        vim.keymap.set('n', 'grr', b.lsp_references,                { buffer = buf, desc = '[G]oto [R]eferences' })
        vim.keymap.set('n', 'gri', b.lsp_implementations,            { buffer = buf, desc = '[G]oto [I]mplementation' })
        vim.keymap.set('n', 'grd', b.lsp_definitions,                { buffer = buf, desc = '[G]oto [D]efinition' })
        vim.keymap.set('n', 'gO',  b.lsp_document_symbols,           { buffer = buf, desc = 'Open Document Symbols' })
        vim.keymap.set('n', 'gW',  b.lsp_dynamic_workspace_symbols,  { buffer = buf, desc = 'Open Workspace Symbols' })
        vim.keymap.set('n', 'grt', b.lsp_type_definitions,           { buffer = buf, desc = '[G]oto [T]ype Definition' })
      end,
    })
  end,
}
