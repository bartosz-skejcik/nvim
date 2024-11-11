return {
	"onsails/lspkind.nvim",
	setup = function()
		require("lspkind").init({
			with_text = true,
			mode = "symbol_text",
			symbol_map = {
				Text = "",
				Method = "",
				Function = "󰊕",
				Constructor = "", -- 
				Field = "",
				Variable = "", -- 
				Class = "",
				Interface = "", -- 
				Module = "",
				Property = "",
				Unit = "󰭍", -- 塞
				Value = "",
				Enum = "", -- 
				Keyword = "",
				Snippet = "",
				Color = "",
				File = "", -- 
				Reference = "", -- 
				Folder = "", -- 
				EnumMember = "", -- 
				Constant = "", -- 
				Struct = "", -- פּ
				Event = "⚡", -- 
				Operator = "",
				Copilot = "",
				TypeParameter = "",
			},
		})
	end,
}
