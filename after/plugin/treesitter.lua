require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "elixir", "heex", "eex", "lua", "cmake", "javascript", "typescript", "help" }, -- only install parsers for elixir and heex
    -- ensure_installed = "all", -- install parsers for all supported languages
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
    },
    autotag = {
        enable = true,
        filetypes = { "html", "jsx", "eelixir", "elixir", "heex" },
    },
}
