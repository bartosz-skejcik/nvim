return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
		-- See Commands section for default commands if you want to lazy load on them

		-- :CopilotChat <input>? - Open chat window with optional input
		-- :CopilotChatOpen - Open chat window
		-- :CopilotChatClose - Close chat window
		-- :CopilotChatToggle - Toggle chat window
		-- :CopilotChatStop - Stop current copilot output
		-- :CopilotChatReset - Reset chat window
		-- :CopilotChatSave <name>? - Save chat history to file
		-- :CopilotChatLoad <name>? - Load chat history from file
		-- :CopilotChatDebugInfo - Show debug information
		-- :CopilotChatModels - View and select available models. This is reset when a new instance is made. Please set your model in init.lua for persistence.
		-- :CopilotChatAgents - View and select available agents. This is reset when a new instance is made. Please set your agent in init.lua for persistence.

		keys = {
			{
				"<leader>cc",
				mode = { "n", "x" },
				"<cmd>:CopilotChatToggle<CR>",
				desc = "Toggle [C]opilot [C]hat",
			},
			{
				"<leader>cs",
				mode = { "n", "x" },
				"<cmd>:CopilotChatStop<CR>",
				desc = "[C]opilot [S]top current output",
			},
			{
				"<leader>cm",
				mode = { "n", "x" },
				"<cmd>:CopilotChatModels<CR>",
				desc = "Show all [C]opilot [M]odels",
			},
			{
				"<leader>cag",
				mode = { "n", "x" },
				"<cmd>:CopilotChatAgents<CR>",
				desc = "Show all [C]opilot [A][G]ents",
			},
		},
	},
}
