-- This plugin adds indentation guides to Neovim.
--
-- Deps:
--  - HiPhish/rainbow-delimiters.nvim
--    This Neovim plugin provides alternating syntax highlighting (“rainbow parentheses”) for Neovim
--
return {
	{ -- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		dependencies = {
			"HiPhish/rainbow-delimiters.nvim",
		},
		main = "ibl",
		-- config = function()
		-- 	local highlight = {
		-- 		"CatppuccinRed",
		-- 		"CatppuccinPeach",
		-- 		"CatppuccinYellow",
		-- 		"CatppuccinGreen",
		-- 		"CatppuccinTeal",
		-- 		"CatppuccinSky",
		-- 		"CatppuccinMauve",
		-- 	}
		--
		-- 	local hooks = require("ibl.hooks")
		-- 	-- create the highlight groups in the highlight setup hook, so they are reset
		-- 	-- every time the colorscheme changes
		-- 	hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
		-- 		vim.api.nvim_set_hl(0, "CatppuccinRed", { fg = "#F38BA8" })
		-- 		vim.api.nvim_set_hl(0, "CatppuccinPeach", { fg = "#FAB387" })
		-- 		vim.api.nvim_set_hl(0, "CatppuccinYellow", { fg = "#F9E2AF" })
		-- 		vim.api.nvim_set_hl(0, "CatppuccinGreen", { fg = "#A6E3A1" })
		-- 		vim.api.nvim_set_hl(0, "CatppuccinTeal", { fg = "#94E2D5" })
		-- 		vim.api.nvim_set_hl(0, "CatppuccinSky", { fg = "#89DCEB" })
		-- 		vim.api.nvim_set_hl(0, "CatppuccinMauve", { fg = "#CBA6F7" })
		-- 	end)
		--
		-- 	vim.g.rainbow_delimiters = { highlight = highlight }
		-- 	require("ibl").setup({
		-- 		scope = { highlight = highlight, enabled = true, show_start = true, show_end = true },
		-- 	})
		--
		-- 	hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
		-- end,
	},
}
