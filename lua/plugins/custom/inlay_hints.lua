return {
	"simrat39/inlay-hints.nvim",
	config = function()
		require("inlay-hints").setup({
			renderer = "inlay-hints/render/eol",
			only_current_line = false,
			eol = {
				parameter = {
					format = function(hints)
						return string.format(" » %s", hints)
					end,
				},
				type = {
					format = function(hints)
						return string.format(" <- %s", hints)
					end,
				},
				right_align = false,
				right_align_padding = 10,
			},
		})
	end,
}
