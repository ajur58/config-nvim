-- Telescope 
local keymap = vim.keymap.set

local builtin = require('telescope.builtin')
keymap('n', '<leader>ff', builtin.find_files,{})
keymap('n', '<leader>fg', builtin.git_files,{})
keymap('n', '<leader>fp', function ()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
