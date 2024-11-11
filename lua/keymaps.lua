-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- The best command ever
vim.keymap.set("n", "<leader>p", '"_dP')

-- Misc Quit and Write
vim.keymap.set("n", "<leader>ww", "<cmd>:w<CR>", { desc = "Write the current file" })
vim.keymap.set("n", "<leader>qq", "<cmd>:qa<CR>", { desc = "Exit out of Nvim" })
vim.keymap.set("n", "<leader>wq", "<cmd>:wqa<CR>", { desc = "Exit out of Nvim" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

local function format_diagnostic(diagnostic)
	local severity = vim.diagnostic.severity[diagnostic.severity]
	local icon = ({ Error = "", Warn = "", Info = "", Hint = "" })[severity] or "➤"
	return string.format("%s %s", icon, diagnostic.message)
end

-- Set up custom diagnostic signs
local signs = { Error = "", Warn = "", Info = "", Hint = "" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Customize the appearance of diagnostic floats
vim.diagnostic.config({
	float = {
		border = "rounded",
		source = true,
		header = "Diagnostics:",
		prefix = "",
	},
})

-- Set up the keymap
vim.keymap.set("n", "<leader>td", function()
	local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
	local diagnostics = vim.diagnostic.get(0, { lnum = cursor_line })

	if #diagnostics == 0 then
		vim.notify("No diagnostics found for the current line.", vim.log.levels.INFO)
		return
	end

	vim.diagnostic.open_float({
		scope = "cursor",
		focusable = false,
		close_events = {
			"CursorMoved",
			"CursorMovedI",
			"BufHidden",
			"InsertCharPre",
			"WinLeave",
		},
		format = format_diagnostic,
		border = "rounded",
	})
end, { desc = "[T]oggle [D]iagnostics window", silent = true, noremap = true })
