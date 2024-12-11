return {
	"mrcjkb/rustaceanvim",
	version = "^5", -- Recommended
	ft = { "rust" },
	dependencies = {
		{
			"neovim/nvim-lspconfig",
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
		},
	},
	config = function()
		vim.g.rustaceanvim = function()
			-- local codelldb_path = extension_path .. "adapter/codelldb"
			-- local liblldb_path = extension_path .. "lldb/lib/liblldb"
			-- local this_os = vim.uv.os_uname().sysname

			-- -- The path is different on Windows
			-- if this_os:find("Windows") then
			-- 	codelldb_path = extension_path .. "adapter\\codelldb.exe"
			-- 	liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
			-- else
			-- 	-- The liblldb extension is .so for Linux and .dylib for MacOS
			-- 	liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
			-- end

			local cfg = require("rustaceanvim.config")

			return {
				-- dap = {
				-- 	adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
				-- },
				server = {
					on_attach = function(client)
						print("Attaching to rustaceanvim")
						-- If you have a specific on_attach function, paste its contents here
						-- Otherwise, you can use a basic on_attach or remove this entirely

						local bufnr = vim.api.nvim_get_current_buf()
						vim.keymap.set("n", "<leader>ca", function()
							vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
							-- or vim.lsp.buf.codeAction() if you don't want grouping.
						end, { silent = true, buffer = bufnr })
						vim.keymap.set(
							"n",
							"K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
							function()
								vim.cmd.RustLsp({ "hover", "actions" })
							end,
							{ silent = true, buffer = bufnr }
						)
						vim.keymap.set("n", "<leader>dd", function()
							vim.cmd.RustLsp("debuggables")
						end, { silent = true, buffer = bufnr })

						client.server_capabilities.document_formatting = true
					end,
					settings = {
						["rust-analyzer"] = {
							checkOnSave = {
								command = "clippy",
							},
						},
					},
				},
			}
		end
	end,
	lazy = false, -- This plugin is already lazy
}
