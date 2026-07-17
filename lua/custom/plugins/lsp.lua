return {
  "neovim/nvim-lspconfig",

  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
  },

  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),

      callback = function(event)
        local lmap = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, {
            buffer = event.buf,
            desc = "LSP: " .. desc,
          })
        end

        lmap("grn", vim.lsp.buf.rename, "[R]e[n]ame")
        lmap("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
        lmap("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        lmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        lmap("K", vim.lsp.buf.hover, "Hover")

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client and client:supports_method("textDocument/documentHighlight") then
          local hl_group =
            vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = hl_group,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = hl_group,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    ------------------------------------------------------------------------
    -- Servers
    ------------------------------------------------------------------------

    local servers = {

      ----------------------------------------------------------------------
      -- C / C++
      ----------------------------------------------------------------------

      clangd = {
        cmd = { "clangd" },

        filetypes = {
          "c",
          "cpp",
          "objc",
          "objcpp",
          "cuda",
        },

        root_markers = {
          "compile_commands.json",
          "compile_flags.txt",
          "CMakeLists.txt",
          ".git",
        },

        init_options = {
          clangdFileStatus = true,
        },
      },

      ----------------------------------------------------------------------

      omnisharp = {},

      pyright = {},

      html = {},

      cssls = {},

      ts_ls = {},

      emmet_ls = {
        filetypes = {
          "html",
          "css",
          "javascript",
          "typescriptreact",
        },
      },

      lua_ls = {
        on_init = function(client)
          client.server_capabilities.documentFormattingProvider = false

          if client.workspace_folders then
            local path = client.workspace_folders[1].name

            if path ~= vim.fn.stdpath("config")
              and (
                vim.uv.fs_stat(path .. "/.luarc.json")
                or vim.uv.fs_stat(path .. "/.luarc.jsonc")
              )
            then
              return
            end
          end

          client.config.settings.Lua =
            vim.tbl_deep_extend("force", client.config.settings.Lua, {
              runtime = {
                version = "LuaJIT",
              },

              workspace = {
                checkThirdParty = false,

                library = vim.tbl_extend(
                  "force",
                  vim.api.nvim_get_runtime_file("", true),
                  {
                    "${3rd}/luv/library",
                    "${3rd}/busted/library",
                  }
                ),
              },
            })
        end,

        settings = {
          Lua = {
            format = {
              enable = false,
            },
          },
        },
      },
    }

    ------------------------------------------------------------------------
    -- Mason
    ------------------------------------------------------------------------

    require("mason-tool-installer").setup({
      ensure_installed = {
        "lua_ls",
        "pyright",
        "html",
        "cssls",
        "ts_ls",
        "emmet_ls",
        "omnisharp",
        "stylua",
      },
    })

    ------------------------------------------------------------------------
    -- Enable Servers
    ------------------------------------------------------------------------

    for name, server in pairs(servers) do
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end
  end,
}
