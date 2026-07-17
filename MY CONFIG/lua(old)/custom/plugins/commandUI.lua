return {
  'folke/noice.nvim',
  event = 'VimEnter',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  opts = {
    cmdline = {
      view = 'cmdline_popup',
    },
  },
}
