-- A high-performance color highlighter for Neovim which has no external dependencies! Written in performant Luajit.
--
return {
	"norcalli/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup({
			"*",
			css = { rgb_fn = true },
		})
	end,
}
