return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      direction = "float",
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal

      local mingw = Terminal:new({
        cmd = 'cmd.exe /c "set CHERE_INVOKING=1&&D:\\msys64\\msys2_shell.cmd -defterm -no-start -mingw64"',
        direction = "float",
        hidden = true,
      })

      local function win_to_msys_path(path)
        local p = path:gsub("\\", "/")
        local drive = p:sub(1, 1):lower()
        return "/" .. drive .. p:sub(3)
      end

      vim.keymap.set("n", "<leader>tt", function()
        mingw:toggle()
      end, { desc = "Toggle MinGW64 Terminal" })

      vim.api.nvim_create_user_command("CDHere", function()
        local dir = win_to_msys_path(vim.fn.expand("%:p:h"))
        mingw:open()
        mingw:send('cd "' .. dir .. '"', true)
      end, { desc = "Open/cd mingw terminal to current file's dir" })

      vim.keymap.set("n", "<leader>th", "<cmd>CDHere<CR>", { desc = "CD mingw to current dir" })

      vim.keymap.set("n", "<leader>gg", function()
        mingw:open()
        mingw:send("cmake --build build && ./build/ForgeEngine.exe", true)
      end, { desc = "Build & Run SDL Engine" })
    end,
  },
}
