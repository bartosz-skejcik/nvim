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

-- return {
-- 	"ellisonleao/gruvbox.nvim",
-- 	priority = 1000,
-- 	config = function()
-- 		local gruvbox = require("gruvbox")
-- 		gruvbox.setup({
-- 			contrast = "hard",
-- 		})
-- 		-- how do i change the contrast level to hard?
-- 		vim.o.background = "dark"
-- 		vim.cmd([[colorscheme gruvbox]])
-- 	end,
-- 	opts = {},
-- }

-- return {
-- 	"rebelot/kanagawa.nvim",
-- 	config = function()
-- 		require("kanagawa").setup({
-- 			compile = true, -- enable compiling the colorscheme
-- 			undercurl = true, -- enable undercurls
-- 			commentStyle = { italic = true },
-- 			functionStyle = {},
-- 			keywordStyle = { italic = true },
-- 			statementStyle = { bold = true },
-- 			typeStyle = {},
-- 			transparent = false, -- do not set background color
-- 			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
-- 			terminalColors = true, -- define vim.g.terminal_color_{0,17}
-- 			colors = { -- add/modify theme and palette colors
-- 				palette = {},
-- 				theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
-- 			},
-- 			overrides = function(colors) -- add/modify highlights
-- 				return {}
-- 			end,
-- 			theme = "wave", -- Load "wave" theme when 'background' option is not set
-- 			background = { -- map the value of 'background' option to a theme
-- 				dark = "wave", -- try "dragon" !
-- 				light = "lotus",
-- 			},
-- 		})
-- 		vim.cmd([[colorscheme kanagawa]])
-- 	end,
-- }

return {
	"sho-87/kanagawa-paper.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		require("kanagawa-paper").setup({
			dimInactive = false,
		})
		vim.cmd("colorscheme kanagawa-paper")
	end,
}
