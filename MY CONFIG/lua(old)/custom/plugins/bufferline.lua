return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- File icons
    "nvim-lua/plenary.nvim",       -- Required dependency
  },
  event = "VeryLazy",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    { "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
    { "<S-l>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
    { "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
    { "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
  },
  opts = {
    options = {
      mode = "buffers", -- Show open buffers (set to "tabs" to show only tabpages)
      style_preset = "default", -- choose from: "default", "minimal", "padded_slant"
      themable = true, -- allow highlight groups to alter styles

      -- Numbers & Sorting
      numbers = "ordinal", -- "none" | "ordinal" | "buffer_id" | "both"
      sort_by = "extension", -- "id" | "extension" | "relative_directory" | "directory"

      -- Indicator Style
      indicator = {
        icon = "▎", -- Left-side active buffer marker
        style = "icon", -- "icon" | "underline" | "none"
      },

      -- Icons Configuration
      buffer_close_icon = "  ",
      modified_icon = "●",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_tab_indicators = true,
      show_duplicate_prefix = true,
      persist_buffer_sort = true,
      move_wraps_at_ends = false,

      -- Constraints
      max_name_length = 18,
      max_prefix_length = 15,
      tab_size = 18,

      -- LSP Diagnostics Integration
      diagnostics = "nvim_lsp", -- "none" | "nvim_lsp" | "coc"
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,

      -- Sidebar Offsets (Pushes bufferline right when a file tree is open)
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree Explorer",
          text_align = "center",
          separator = true,
        },
        {
          filetype = "NvimTree",
          text = "File Explorer",
          text_align = "left",
          separator = true,
        },
      },

      -- Visual Grouping & Filtering
      color_icons = true,
      get_element_icon = function(element)
        local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = true })
        return icon, hl
      end,
      
      -- Custom Grouping Rules (e.g., separate tests or configs)
      groups = {
        items = {
          {
            name = "Tests",
            priority = 2,
            auto_close = false,
            matcher = function(buf)
              return buf.name:match("%_spec%.lua") or buf.name:match("%.test%.")
            end,
          },
          {
            name = "Docs",
            priority = 1,
            auto_close = false,
            matcher = function(buf)
              return buf.name:match("%.md") or buf.name:match("%.txt")
            end,
          },
        },
      },
    },
    
    -- Aesthetic Highlight Customizations
    highlights = {
      fill = {
        bg = { attribute = "bg", highlight = "TabLine" },
      },
      background = {
        bg = { attribute = "bg", highlight = "TabLine" },
      },
      buffer_selected = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "Normal" },
        bold = true,
        italic = true,
      },
      modified_selected = {
        fg = { attribute = "fg", highlight = "String" },
        bg = { attribute = "bg", highlight = "Normal" },
      },
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
    
    -- Auto-fix layout when a buffer is closed
    vim.api.nvim_create_autocmd("BufAdd", {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}
