return {
	"github/copilot.vim",
}

-- return {
-- 	"huggingface/llm.nvim",
-- 	enabled = true,
-- 	even = "VeryLazy",
-- 	keys = {
-- 		{
-- 			"<CR>",
-- 			function()
-- 				require("llm.completion").complete()
-- 			end,
-- 			mode = "i",
-- 			desc = "complete",
-- 		},
-- 	},
-- 	opts = {
-- 		lsp = {
-- 			bin_path = vim.api.nvim_call_function("stdpath", { "data" }),
-- 		},
-- 		backend = "ollama",
-- 		model = "deepseek-r1:latest",
-- 		url = "http://localhost:11434",
-- 	},
-- }
