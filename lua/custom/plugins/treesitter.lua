return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",

    config = function()
      require("nvim-treesitter").setup()

      vim.env.CC = "gcc"

      require("nvim-treesitter").install({
        "lua",
        "vim",
        "vimdoc",
        "c",
        "cpp",
        "python",
        "javascript",
        "typescript",
        "html",
        "css",
        "json",
        "bash",
      })
    end,
  },
}
