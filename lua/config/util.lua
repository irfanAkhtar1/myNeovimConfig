local M = {}

function M.set_transparent()
  local groups = {
    'Normal', 'NormalNC', 'NormalFloat', 'FloatBorder',
    'NeoTreeNormal', 'NeoTreeNormalNC', 'SignColumn',
  }
  for _, g in ipairs(groups) do
    vim.api.nvim_set_hl(0, g, { bg = 'none' })
  end
end

return M
