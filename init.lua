vim.g.mapleader = " "

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

require("ajur58")

-- Set colorscheme after plugins load
vim.cmd.colorscheme("habamax")

-- Reload file when aider makes changes
vim.opt.autoread = true
vim.api.nvim_create_augroup("autoreload", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
  group = "autoreload",
  callback = function()
    vim.cmd("checktime")
  end,
})

-- Got to run npm install -g @tailwindcss/language-server then install vscode html lang stuff with npm i
-- require'lspconfig'.tailwindcss.setup{}
