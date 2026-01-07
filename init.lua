-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Enable case-insensitive search by default (with smartcase for uppercase queries)
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- telescope.nvim
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('telescope').setup({
          defaults = {
            layout_strategy = 'horizontal',
            layout_config = { height = 0.95, width = 0.95 },
            file_previewer = require('telescope.previewers').vim_buffer_cat.new,
            grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
            case_mode = "smart_case",
          },
          pickers = {
            find_files = {
              case_mode = "ignore_case",
              hidden = true,
              no_ignore = false,
            },
            live_grep = {
              additional_args = {
                "--ignore-case",
                "--hidden",
                "--glob",
                "!**/.git/*"
              },
            },
          },
        })
      end,
      keys = {
        { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find files (Telescope)' },
        { '<leader>fF', "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", desc = 'Find all files (incl. hidden & ignored)' },
        { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Live grep (search inside files)' },
      },
    },

    -- neo-tree.nvim
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("neo-tree").setup({
          sources = { "filesystem", "buffers", "git_status" },
          window = {
            position = "left",
            width = 30,
            mappings = {
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["~"] = "set_home",
              ["<cr>"] = "open",
              ["|"] = "open_vsplit",
              ["s"] = "open_split",
              ["o"] = "open_drop",
              ["c"] = "close_node",
              ["C"] = "collapse_all_nodes",
              ["z"] = "expand_all_nodes",
              ["a"] = "add",
              ["d"] = "delete",
              ["r"] = "rename",
              ["y"] = "copy_to_clipboard",
              ["x"] = "cut_to_clipboard",
              ["p"] = "paste_from_clipboard",
              ["q"] = "close_window",
              ["R"] = "refresh",
              ["?"] = "toggle_help",
            },
          },
          filesystem = {
            follow_current_file = {
              enabled = true,
              leave_dirs_open = false,
            },
            hijack_netrw_behavior = "open_current",
          },
        })
      end,
      keys = {
        { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
      },
    },

    -- Comment.nvim - modern, Tree-sitter aware commenting
    {
      "numToStr/Comment.nvim",
      event = "VeryLazy",
      opts = {
        toggler = {
          line = 'gcc',  -- Toggle line comment
          block = 'gbc', -- Toggle block comment
        },
        opleader = {
          line = 'gc',
          block = 'gb',
        },
        extra = {
          above = 'gcO', -- Add comment above
          below = 'gco', -- Add comment below
          eol = 'gcA',   -- Add comment at end of line
        },
      },
      config = function(_, opts)
        require('Comment').setup(opts)
      end,
    },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})
