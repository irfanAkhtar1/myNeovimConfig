-- return {
--   'ellisonleao/gruvbox.nvim',
--   priority = 1000,
--   config = function()
--     require('gruvbox').setup({
--       transparent_mode = true,
--     })
--     vim.cmd.colorscheme 'gruvbox'
--
--     vim.opt.termguicolors = true
--     -- force transparency after colorscheme loads
--     vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
--     vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
--     vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
--     vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
--     vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = 'none' })
--     vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { bg = 'none' })
--   end,
-- }


return {
  {
    "projekt0n/caret.nvim",
    lazy = false,
    priority = 1000,

    config = function()
      vim.opt.termguicolors = true

      vim.cmd.colorscheme("caret")

      -- Hide ~ at end of buffer
      vim.opt.fillchars:append({
        eob = " ",
      })

      -- Transparent background
      local groups = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "SignColumn",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "EndOfBuffer",
      }

      for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "NONE", bg = "NONE" })
        vim.api.nvim_set_hl(0, "VertSplit", { fg = "NONE", bg = "NONE" }) -- for older Neovim
      end
    end,
  },
}
