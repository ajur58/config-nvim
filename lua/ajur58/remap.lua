vim.g.mapleader = " "

-- Open Nvim Tree Explorer
vim.keymap.set("n", "<leader>mc", ":NvimTreeToggle<cr>")

-- Exit Terminal mode
vim.keymap.set("t", "<leader><Esc>", "<C-\\><C-n>")

-- Code Formatter
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
-- Format On Save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- Shorten function name
local keymap = vim.keymap.set

-- Move between windows
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-l>", "<C-w>l")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-j>", "<C-w>j")

-- Telescope
local builtin = require('telescope.builtin')
keymap('n', '<leader>ff', builtin.find_files, {})
keymap('n', '<leader>fg', builtin.git_files, {})
keymap('n', '<leader>fp', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

-- In Visual mode, move lines up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- When joining two lines, it keeps the cursor at the beginning of the line
vim.keymap.set("n", "J", "mzJ`z")

-- greatest remap ever, for copy-pasting over highlighted text and keeping buffer
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever: copy into real clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Avoid pressing Q
vim.keymap.set("n", "Q", "<nop>")

-- Quick Fix List Navigation -> note, look into it
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Scroll half page and move to middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
