-- return {
-- 	"catppuccin/nvim",
-- 	as = "catppuccin",
-- 	config = function()
-- 		require("catppuccin").setup({
-- 			flavour = "mocha", -- Choose your flavor: latte, frappe, macchiato, mocha
-- 			integrations = {
-- 				cmp = true,
-- 				gitsigns = true,
-- 				nvimtree = true,
-- 				treesitter = true,
-- 				notify = false,
-- 				mini = {
-- 					enabled = true,
-- 					indentscope_color = "",
-- 				},
-- 			},
-- 		})
-- 		vim.cmd.colorscheme("catppuccin")
-- 	end,
-- }

return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		local gruvbox = require("gruvbox")
		gruvbox.setup({
			contrast = "hard",
		})
		-- how do i change the contrast level to hard?
		vim.o.background = "dark"
		vim.cmd([[colorscheme gruvbox]])
	end,
	opts = {},
}
