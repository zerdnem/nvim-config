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
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
    {
      'dmtrKovalenko/fff.nvim',
      build = function()
        -- this will download prebuild binary or try to use existing rustup toolchain to build from source
        -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
        require("fff.download").download_or_build_binary()
      end,
      -- if you are using nixos
      -- build = "nix run .#release",
      opts = { -- (optional)
        debug = {
          enabled = true, -- we expect your collaboration at least during the beta
          show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
        },
      },
      -- No need to lazy-load with lazy.nvim.
      -- This plugin initializes itself lazily.
      lazy = false,
      keys = {
        {
          "ff", -- try it if you didn't it is a banger keybinding for a picker
          function() require('fff').find_files() end,
          desc = 'FFFind files',
        }
      }
    },
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.8',  -- Recommended: Pin to a stable tag; update as needed
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('telescope').setup({
          defaults = {
            -- Basic config; customize as needed (e.g., layout, sorting)
            layout_strategy = 'horizontal',
            layout_config = { height = 0.95, width = 0.95 },
            -- Enable preview for grep results
            file_previewer = require('telescope.previewers').vim_buffer_cat.new,
            grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
          },
          pickers = {
            find_files = {
              -- Integrate with fff if desired, but default is fine
            },
            live_grep = {
              -- Default to ripgrep; assumes rg is installed (brew install ripgrep on macOS, etc.)
              additional_args = { "--hidden", "--glob", "!**/.git/*" },  -- Search hidden files, skip .git
            },
          },
        })
      end,
      keys = {
        { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Live grep (search inside files)' },
        -- Optional: Add this if you want Telescope's file finder as a fallback (avoids overlap with fff)
        -- { '<leader>tf', '<cmd>Telescope find_files<cr>', desc = 'Telescope find files' },
      },
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
