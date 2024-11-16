local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- the plugin manager can manage itself
  { "folke/lazy.nvim" },
  
  -- Navigation and utilities
  {
    "theprimeagen/harpoon",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")
      
      vim.keymap.set("n", "<leader>a", mark.add_file)
      vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
      vim.keymap.set("n", "<C-f>", function() ui.nav_file(1) end)
      vim.keymap.set("n", "<C-s>", function() ui.nav_file(2) end)
      vim.keymap.set("n", "<C-t>", function() ui.nav_file(3) end)
      vim.keymap.set("n", "<C-n>", function() ui.nav_file(4) end)
    end
  },
  { 
    "mbbill/undotree",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end
  },
  { 
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
    end
  },
  
  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "javascript",
          "typescript",
          "elixir",
          "heex",
          "eex",
          "cmake"
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = {
          enable = true
        },
      })
    end
  },

  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local function open_nvim_tree(data)
          -- buffer is a [No Name]
          local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

          -- buffer is a directory
          local directory = vim.fn.isdirectory(data.file) == 1

          if not no_name and not directory then
              return
          end

          -- change to the directory
          if directory then
              vim.cmd.cd(data.file)
          end

          -- open the tree
          require("nvim-tree.api").tree.open()
      end

      require("nvim-tree").setup({
          view = {
              width = 35,
          },
          update_focused_file = {
              enable = true,
              update_root = false,
              ignore_list = {},
          },
      })
      -- Open Tree when opening a folder
      vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
    end
  },

  -- Telescope File Search
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    lazy = false,
    priority = 1000,
    keys = {
      { "<leader>ff", desc = "Find Files" },
      { "<leader>fg", desc = "Git Files" },
      { "<leader>fl", desc = "Live Grep" },
      { "<leader>fs", desc = "Grep String" },
      { "<leader>fb", desc = "Buffers" },
      { "<leader>fh", desc = "Help Tags" },
      { "<leader>fp", desc = "Grep Prompt" },
    },
    dependencies = { 
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
      vim.keymap.set('n', '<leader>fl', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fs', builtin.grep_string, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      vim.keymap.set('n', '<leader>fp', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end)

      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { 
            "node_modules", 
            ".git/",
            "target/",
            "build/",
            "dist/"
          },
          path_display = { "truncate" },
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true
          }
        }
      })
    end
  },

  -- Theme
  {
    "rebelot/kanagawa.nvim",
    config = function()
      function ColorMyPencils(color)
        color = color or "kanagawa"
        vim.cmd.colorscheme(color)

        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      end

      ColorMyPencils()
    end,
    priority = 1000,
  },

  -- LSP Support
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
    },
    config = function()
      require("neodev").setup()
    end
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "rafamadriz/friendly-snippets",
    },
  },

  -- Coding Stats
  "wakatime/vim-wakatime",
})
