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
		-- Keymaps moved to remap.lua
	},
	{
		"mbbill/undotree",
		event = "VeryLazy",
		-- Keymaps moved to remap.lua
	},
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		-- Keymaps moved to remap.lua
	},

	-- Treesitter for syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		config = function()
			local treesitter_config = require("nvim-treesitter.configs")
			treesitter_config.setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"javascript",
					"typescript",
					"elixir",
					"heex",
					"eex",
					"cmake",
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
			})

			-- Enable autotag
			require("nvim-ts-autotag").setup()
		end,
	},

	-- File Explorer
	{
		"nvim-tree/nvim-web-devicons",
		opts = { default = true },
	},

	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-web-devicons").setup({ default = true }) -- 🔥 this must come first
			require("nvim-tree").setup({
				view = { width = 35 },
				update_focused_file = {
					enable = true,
					update_root = false,
					ignore_list = {},
				},
				renderer = {
					icons = {
						show = {
							file = true,
							folder = true,
							folder_arrow = true,
							git = true,
						},
					},
				},
			})
		end,
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
			-- Keymaps moved to remap.lua
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						"node_modules",
						".git/",
						"target/",
						"build/",
						"distt",
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
						hidden = true,
					},
				},
			})
		end,
	},

	-- Theme
	-- {
	--   "rebelot/kanagawa.nvim",
	--   config = function()
	--     function ColorMyPencils(color)
	--       color = "kanagawa-dragon"
	--       vim.cmd.colorscheme(color)
	--
	--       vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	--       vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	--     end
	--
	--     ColorMyPencils()
	--   end,
	--   priority = 1000,
	-- },
	{
		"zenbones-theme/zenbones.nvim",
		-- Optionally install Lush. Allows for more configuration or extending the colorscheme
		-- If you don't want to install lush, make sure to set g:zenbones_compat = 1
		-- In Vim, compat mode is turned on as Lush only works in Neovim.
		dependencies = "rktjmp/lush.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			--     vim.g.zenbones_darken_comments = 45
			vim.cmd.colorscheme("forestbones")
		end,
	},

	-- LSP Support
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			require("neodev").setup()
		end,
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

	-- Easy commenting
	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any custom configurations here
		},
		lazy = false,
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = " ",
				tab_char = " ",
			},
			scope = { enabled = false },
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		},
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "zenbones",
					component_separators = "|",
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
					lualine_b = { "filename", "branch" },
					lualine_c = { "fileformat" },
					lualine_x = { "encoding", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
				},
			})
		end,
	},

	-- Keybinding helper
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
		},
	},

	{ "christoomey/vim-tmux-navigator" },
	{ "WhoIsSethDaniel/mason-tool-installer.nvim" },

	-- Git signs in the gutter (minimal config)
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = true, -- Use default configuration
	},

	-- GitHub Copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					keymap = {
						accept = "<S-Tab>", -- Tab to accept
						next = "<C-n>", -- Ctrl+n to see next suggestion
						prev = "<C-p>", -- Ctrl+p to see previous suggestion
						dismiss = "<C-e>", -- Ctrl+e to dismiss
					},
				},
				filetypes = {
					markdown = true,
					help = true,
					gitcommit = true,
					["."] = true,
				},
			})
		end,
	},

	-- GitHub Copilot Chat
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" },
		},
		opts = {
			debug = false,
			prompts = {
				Explain = "Explain how this code works:",
				Review = "Review this code and make suggestions for improvement:",
				Tests = "Suggest unit tests for this code:",
				Refactor = "Suggest a refactoring for this code:",
			},
		},
		build = function()
			vim.notify("Please install 'CopilotChat.nvim' dependencies by running ':CopilotChatInstall'")
		end,
	},

	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({
				auto_open = false, -- Do not open automatically
				auto_close = true, -- Auto-close when no items
				use_diagnostic_signs = true,
			})

			-- Keymaps moved to remap.lua
		end,
	},

	{
		"folke/zen-mode.nvim",
		-- Keymaps moved to remap.lua
	},
})
