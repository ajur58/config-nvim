local execute = vim.api.nvim_command
local fn = vim.fn
local fmt = string.format

local pack_path = fn.stdpath("data") .. "/site/pack"

-- ensure a given plugin from github.com/<user>/<repo> is cloned in the pack/packer/start directory
local function ensure(user, repo)
    local install_path = fmt("%s/packer/start/%s", pack_path, repo)
    if fn.empty(fn.glob(install_path)) > 0 then
        execute(fmt("!git clone https://github.com/%s/%s %s", user, repo, install_path))
        execute(fmt("packadd %s", repo))
    end
end

-- ensure the plugin manager is installed
ensure("wbthomason", "packer.nvim")

-- PACKER IS NO LONGER MAINTAINED, SWITCH TO LAZY.NVIM
require('packer').startup(function(use)
    -- install all the plugins you need here

    -- the plugin manager can manage itself
    use { 'wbthomason/packer.nvim' }
    use { 'theprimeagen/harpoon' }

    -- treesitter for syntax highlighting and more
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    -- File Explorer
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        }
    }

    -- Telescope File Search
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        requires = { { 'nvim-lua/plenary.nvim' }, 'BurntSushi/ripgrep' }
    }
    -- for light theme try https://github.com/rmehri01/onenord.nvim
    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            require("rose-pine").setup()
            vim.cmd('colorscheme rose-pine')
        end
    })

    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    -- LSP Support
    use { 'neovim/nvim-lspconfig' }             -- Required
    use { 'williamboman/mason.nvim' }           -- Optional
    use { 'williamboman/mason-lspconfig.nvim' } -- Optional

    -- Autocompletion
    use { 'hrsh7th/nvim-cmp' }     -- Required
    use { 'hrsh7th/cmp-nvim-lsp' } -- Required
    use { 'hrsh7th/cmp-buffer' }   -- Optional
    use { 'hrsh7th/cmp-path' }     -- Optional
    -- use { 'saadparwaiz1/cmp_luasnip' } -- Optional
    -- use { 'hrsh7th/cmp-nvim-lua' } -- Optional

    -- Snippets
    use { 'hrsh7th/cmp-vsnip' }            -- Optional
    use { 'hrsh7th/vim-vsnip' }            -- Optional
    -- use { 'L3MON4D3/LuaSnip' } -- Required
    use { 'rafamadriz/friendly-snippets' } -- Optional

    -- Coding Stats
    use 'wakatime/vim-wakatime'
end)
