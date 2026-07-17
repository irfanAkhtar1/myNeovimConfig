return {
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
    notify_on_error = false,
    format_on_save  = function(bufnr)
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
}
