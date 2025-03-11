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

-- search and replace
keymap("n", "S", ":%s//g<Left><Left>")
-- Move between windows
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-l>", "<C-w>l")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-j>", "<C-w>j")


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


-- Comment.nvim keymaps (though it works automatically with gcc and gc)
vim.keymap.set('n', '<leader>/', function()
  require("Comment.api").toggle.linewise.current()
end)
vim.keymap.set('v', '<leader>/', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

vim.keymap.set('n', '<leader><leader>', '<C-^>', { desc = "Switch to the last file" })

-- TMUX remaps
vim.g.tmux_navigator_no_mappings = 1
vim.api.nvim_set_keymap("n", "<C-h>", ":TmuxNavigateLeft<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", ":TmuxNavigateDown<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":TmuxNavigateUp<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", ":TmuxNavigateRight<CR>", { silent = true })

-- Copilot Chat keybindings
vim.keymap.set('v', '<leader>ce', ':CopilotChatExplain<CR>', { desc = "Copilot explain code" })
vim.keymap.set('v', '<leader>cr', ':CopilotChatReview<CR>', { desc = "Copilot review code" })
vim.keymap.set('v', '<leader>ct', ':CopilotChatTests<CR>', { desc = "Copilot suggest tests" })
vim.keymap.set('v', '<leader>cf', ':CopilotChatRefactor<CR>', { desc = "Copilot suggest refactor" })

-- Special paste mode handler
vim.keymap.set('n', '<leader>p', function()
  -- Enter paste mode
  local old_paste = vim.opt.paste:get()
  local old_ai = vim.opt.autoindent:get()
  local old_si = vim.opt.smartindent:get()

  vim.opt.paste = true
  vim.opt.autoindent = false
  vim.opt.smartindent = false

  -- Wait for paste
  vim.cmd('normal! "+p')

  -- Restore previous settings
  vim.opt.paste = old_paste
  vim.opt.autoindent = old_ai
  vim.opt.smartindent = old_si
end, { noremap = true, desc = "Paste without formatting" })

