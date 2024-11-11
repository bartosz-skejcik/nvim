-- LSP Plugins
return {
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by nvim-cmp
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Brief aside: **What is LSP?**
			--
			-- LSP is an initialism you've probably heard, but might not understand what it is.
			--
			-- LSP stands for Language Server Protocol. It's a protocol that helps editors
			-- and language tooling communicate in a standardized fashion.
			--
			-- In general, you have a "server" which is some tool built to understand a particular
			-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
			-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
			-- processes that communicate with some "client" - in this case, Neovim!
			--
			-- LSP provides Neovim with features like:
			--  - Go to definition
			--  - Find references
			--  - Autocompletion
			--  - Symbol Search
			--  - and more!
			--
			-- Thus, Language Servers are external tools that must be installed separately from
			-- Neovim. This is where `mason` and related plugins come into play.
			--
			-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
			-- and elegantly composed help section, `:help lsp-vs-treesitter`

			--  This function gets run when an LSP attaches to a particular buffer.
			--    That is to say, every time a new file is opened that is associated with
			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
			--    function will be executed to configure the current buffer

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(args)
					-- NOTE: Remember that Lua is a real programming language, and as such it is possible
					-- to define small helper and utility functions so you don't have to repeat yourself.
					--
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = "LSP: " .. desc })
					end

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = args.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = args.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			local lsp_flags = { debounce_text_changes = 150 }
			local on_attach = function(client, bufnr)
				local function buf_set_keymap(...)
					vim.api.nvim_buf_set_keymap(bufnr, ...)
				end

				local function buf_set_option(...)
					vim.api.nvim_set_option_value(bufnr, ...)
				end

				buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
				local opts = { noremap = true, silent = true }

				buf_set_keymap("n", "gD", "<cmd>Telescope lsp_type_definitions<CR>", opts)
				buf_set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
				buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
				buf_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
				buf_set_keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
				buf_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
				buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
				buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
				buf_set_keymap("n", "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", opts)
				client.server_capabilities.document_formatting = true
			end
			local lspconfig = require("lspconfig")
			lspconfig.emmet_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				flags = lsp_flags,
			})

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

			-- 1. Import Mason Registry
			local mason_registry = require("mason-registry")
			local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
				.. "/node_modules/@vue/language-server"

			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`tsserver`) will work just fine

				ts_ls = {
					init_options = {
						plugins = {
							{
								name = "@vue/typescript-plugin",
								location = vue_language_server_path,
								languages = { "vue" },
							},
						},
					},
					capabilities = capabilities,
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
					-- handlers = {
					-- 	["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
					-- 		if result.diagnostics == nil then
					-- 			return
					-- 		end
					--
					-- 		-- ignore some tsserver diagnostics
					-- 		local idx = 1
					-- 		while idx <= #result.diagnostics do
					-- 			local entry = result.diagnostics[idx]
					--
					-- 			local formatter = require("format-ts-errors")[entry.code]
					-- 			entry.message = formatter and formatter(entry.message) or entry.message
					--
					-- 			-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
					-- 			if entry.code == 80001 then
					-- 				-- { message = "File is a CommonJS module; it may be converted to an ES module.", }
					-- 				table.remove(result.diagnostics, idx)
					-- 			else
					-- 				idx = idx + 1
					-- 			end
					-- 		end
					--
					-- 		vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
					-- 	end,
					-- },
				},

				html = {
					capabilities = capabilities,
					filetypes = {
						"templ",
						"html",
						"css",
						"javascriptreact",
						"typescriptreact",
						"javascript",
						"typescript",
						"jsx",
						"tsx",
					},
				},

				htmx = {
					capabilities = capabilities,
					filetypes = { "html", "templ" },
				},

				emmet_language_server = {
					capabilities = capabilities,
					filetypes = {
						"templ",
						"html",
						"css",
						"javascriptreact",
						"typescriptreact",
						"javascript",
						"typescript",
						"jsx",
						"tsx",
						"markdown",
					},
				},

				["vue-language-server"] = { -- This is Volar
					capabilities = capabilities,
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
				},

				volar = {
					capabilities = capabilities,
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
					init_options = {
						typescript = {
							-- tsdk = vim.fn.expand("$HOME/.npm-global/lib/node_modules/typescript/lib"),
							-- or alternative location:
							tsdk = vim.fn.expand(
								"$HOME/.nvm/versions/node/v20.17.0/lib/node_modules/lib/node_modules/typescript/lib"
							),
						},
						vue = {
							hybridMode = true,
						},
					},
				},

				prismals = {
					capabilities = capabilities,
				},

				tailwindcss = {
					capabilities = capabilities,
					filetypes = {
						"templ",
						"html",
						"css",
						"vue",
						"javascriptreact",
						"typescriptreact",
						"javascript",
						"typescript",
						"jsx",
						"tsx",
					},
					root_dir = require("lspconfig").util.root_pattern(
						"tailwind.config.js",
						"tailwind.config.cjs",
						"tailwind.config.mjs",
						"tailwind.config.ts",
						"postcss.config.js",
						"postcss.config.cjs",
						"postcss.config.mjs",
						"postcss.config.ts",
						"package.json",
						"node_modules",
						".git"
					),
					init_options = {
						userLanguages = {
							vue = "html",
						},
					},
				},

				eslint = {
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "html" },
					capabilities = capabilities,
				},

				marksman = {
					capabilties = capabilities,
				},

				-- gleam = {
				-- capabilities = capabilities,
				-- },

				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--pch-storage=memory",
						"--all-scopes-completion",
						"--pretty",
						"--header-insertion=never",
						"-j=4",
						"--inlay-hints",
						"--header-insertion-decorators",
						"--function-arg-placeholders",
						"--completion-style=detailed",
					},
					filetypes = { "c", "cpp", "objc", "objcpp" },
					root_dir = require("lspconfig").util.root_pattern("src"),
					init_option = { fallbackFlags = { "-std=c++2a" } },
					capabilities = capabilities,
				},

				omnisharp = {
					cmd = { "omnisharp" },
					-- filetypes = { "csharp" },
					-- root_dir = require("lspconfig").util.root_pattern("*.sln"),
					capabilities = capabilities,
				},

				lua_ls = {
					-- cmd = {...},
					-- filetypes = { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
					capabilities = capabilities,
				},
			}

			-- Ensure the servers and tools above are installed
			--  To check the current status of installed tools and/or manually install
			--  other tools, you can run
			--    :Mason
			--
			--  You can press `g?` for help in this menu.
			require("mason").setup()

			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"html-lsp",
				"vue-language-server",
				"volar",
				"tailwindcss-language-server",
				"emmet_language_server",
				"eslint-lsp",
				"prettierd",
				"intelephense",
				"emmet_ls",
				"rust-analyzer",
				"gopls",
				"prettier",
				"htmx",
				"cssls",
				"ts_ls",
				"clangd",
				"marksman",
				"prismals",
				"omnisharp",
				"volar",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for tsserver)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
					-- ["rust_analyzer"] = function()
					-- 	require("rustaceanvim").setup({})
					-- end,
				},
			})
		end,
	},
}
-- vim: ts=2 sts=2 sw=2 et
