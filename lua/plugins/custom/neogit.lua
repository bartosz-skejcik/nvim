-- An interactive and powerful Git interface for Neovim, inspired by Magit
return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration

		-- Only one of these is needed.
		"nvim-telescope/telescope.nvim", -- optional
	},
	config = true,
	keys = {
		{
			"<leader>gs",
			function()
				require("neogit").open()
			end,
			mode = "n",
			desc = "[G]it [S]tatus",
		},
		{
			"<leader>gc",
			function()
				vim.cmd("Neogit commit")
			end,
			mode = "n",
			desc = "[G]it [C]ommit",
		},
		{
			"<leader>gp",
			function()
				vim.cmd("Neogit pull")
			end,
			mode = "n",
			desc = "[G]it [P]ull",
		},
		{
			"<leader>gP",
			function()
				vim.cmd("Neogit push")
			end,
			mode = "n",
			desc = "[G]it [P]ush",
		},
		{
			"<leader>gb",
			function()
				vim.cmd("Telescope git_branches")
			end,
			mode = "n",
			desc = "[G]it [B]ranches",
		},
		{
			"<leader>gB",
			function()
				vim.cmd("G blame")
			end,
			mode = "n",
			desc = "[G]it [B]lame",
		},
	},
}
