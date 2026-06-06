-- ========================================
-- UI関連プラグイン
-- ========================================

return {
  -- Lualine: ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Bufferline: タブライン
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          indicator = {
            style = "icon",
            icon = "▎",
          },
          diagnostics = "nvim_lsp",
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            },
          },
          show_buffer_close_icons = true,
          show_close_icon = true,
          separator_style = "thin",
        },
      })
    end,
  },

  -- Indent-blankline: インデントガイド
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = false,
        },
      })
    end,
  },

  -- Which-key: キーバインドヘルパー
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        preset = "modern",
      })

      -- グループ名の設定
      wk.add({
        { "<leader>a", group = "AI/Copilot" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "診断" },
        { "<leader>f", group = "検索" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Hunk" },
        { "<leader>l", group = "LSP" },
      })
    end,
  },

  -- Noice: モダンなUI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
    end,
  },

  -- Trouble: 診断・参照一覧
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>dd", "<cmd>Trouble diagnostics toggle<cr>", desc = "診断一覧" },
    },
    config = function()
      require("trouble").setup({})
    end,
  },

  -- Alpha: スタート画面
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ██╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗  ██║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔██╗ ██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╗██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚████║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝  ╚═══╝ ",
        "                                                     ",
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  ファイル検索", ":Telescope find_files <CR>"),
        dashboard.button("r", "  最近使ったファイル", ":Telescope oldfiles <CR>"),
        dashboard.button("g", "  テキスト検索", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  設定", ":e ~/.config/nvim/init.lua <CR>"),
        dashboard.button("q", "  終了", ":qa<CR>"),
      }

      alpha.setup(dashboard.opts)
    end,
  },

  -- Colorizer: カラーコードを色で表示
  {
    "catgoose/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = false,
          RRGGBBAA = true,
          AARRGGBB = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          mode = "background",
          tailwind = "both",
        },
        buftypes = {},
      })
    end,
  },
}
