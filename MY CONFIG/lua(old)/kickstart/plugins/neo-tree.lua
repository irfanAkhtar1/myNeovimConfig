return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  config = function()
    require('neo-tree').setup({
      filesystem = {
        window = {
          mappings = {
            ['\\'] = 'close_window',
            ['d'] = function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.ui.input({ prompt = 'Delete "' .. node.name .. '"? (y/n): ' }, function(input)
                if input == 'y' then
                  vim.fn.jobstart({
                    'powershell', '-NoProfile', '-Command',
                    string.format(
                      'Add-Type -AssemblyName Microsoft.VisualBasic; ' ..
                      '[Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile("%s", "OnlyErrorDialogs", "SendToRecycleBin"); ' ..
                      '[Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory("%s", "OnlyErrorDialogs", "SendToRecycleBin")',
                      path, path
                    )
                  }, {
                    on_exit = function()
                      require('neo-tree.sources.manager').refresh('filesystem')
                    end
                  })
                end
              end)
            end,
          },
        },
      },
    })
  end,
}
