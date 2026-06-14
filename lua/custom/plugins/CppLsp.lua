return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd" }
      })

      vim.lsp.config('clangd', {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
          "--query-driver=D:/msys64/ucrt64/bin/g++.exe",
        },
        root_markers = { '.git', 'compile_flags.txt', 'compile_commands.json', '.' },
        filetypes = { 'c', 'cpp' },
      })
      vim.lsp.enable('clangd')
    end
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = true,
  }
}
